import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/user.dart';
import '../models/meal.dart';
import '../models/order.dart';
import '../models/restaurant.dart';

/// Service de base de données locale pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
class DatabaseService {
  /// Boxes Hive pour les différentes entités
  late Box<Map> _userBox;
  late Box<Map> _mealBox;
  late Box<Map> _orderBox;
  late Box<Map> _restaurantBox;
  late Box<String> _settingsBox;
  
  /// Indique si le service est initialisé
  bool _isInitialized = false;

  /// Getter pour vérifier l'initialisation
  bool get isInitialized => _isInitialized;

  /// Initialise la base de données locale
  Future<void> initialize() async {
    try {
      // Initialiser Hive
      await Hive.initFlutter();
      
      // Ouvrir les boxes
      _userBox = await Hive.openBox<Map>('users');
      _mealBox = await Hive.openBox<Map>('meals');
      _orderBox = await Hive.openBox<Map>('orders');
      _restaurantBox = await Hive.openBox<Map>('restaurants');
      _settingsBox = await Hive.openBox<String>('settings');
      
      _isInitialized = true;
      
      if (kDebugMode) {
        print('DatabaseService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing DatabaseService: $e');
      }
      rethrow;
    }
  }

  /// Ferme toutes les boxes
  Future<void> close() async {
    try {
      await _userBox.close();
      await _mealBox.close();
      await _orderBox.close();
      await _restaurantBox.close();
      await _settingsBox.close();
      
      _isInitialized = false;
      
      if (kDebugMode) {
        print('DatabaseService closed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error closing DatabaseService: $e');
      }
    }
  }

  /// Efface toutes les données locales
  Future<void> clearAll() async {
    if (!_isInitialized) return;
    
    try {
      await _userBox.clear();
      await _mealBox.clear();
      await _orderBox.clear();
      await _restaurantBox.clear();
      await _settingsBox.clear();
      
      if (kDebugMode) {
        print('All local data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing data: $e');
      }
    }
  }

  // ==================== USER OPERATIONS ====================

  /// Sauvegarde un utilisateur localement
  Future<void> saveUser(User user) async {
    if (!_isInitialized) throw Exception('Database not initialized');
    
    try {
      await _userBox.put(user.id, user.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user: $e');
      }
      rethrow;
    }
  }

  /// Récupère un utilisateur par ID
  User? getUser(String userId) {
    if (!_isInitialized) return null;
    
    try {
      final userData = _userBox.get(userId);
      return userData != null ? User.fromJson(Map<String, dynamic>.from(userData)) : null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user: $e');
      }
      return null;
    }
  }

  /// Récupère l'utilisateur actuel (premier dans la box)
  User? getCurrentUser() {
    if (!_isInitialized) return null;
    
    try {
      if (_userBox.isEmpty) return null;
      final userData = _userBox.getAt(0);
      return userData != null ? User.fromJson(Map<String, dynamic>.from(userData)) : null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current user: $e');
      }
      return null;
    }
  }

  /// Supprime un utilisateur
  Future<void> deleteUser(String userId) async {
    if (!_isInitialized) return;
    
    try {
      await _userBox.delete(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
    }
  }

  // ==================== MEAL OPERATIONS ====================

  /// Sauvegarde un repas localement
  Future<void> saveMeal(Meal meal) async {
    if (!_isInitialized) throw Exception('Database not initialized');
    
    try {
      await _mealBox.put(meal.id, meal.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving meal: $e');
      }
      rethrow;
    }
  }

  /// Sauvegarde plusieurs repas
  Future<void> saveMeals(List<Meal> meals) async {
    if (!_isInitialized) return;
    
    try {
      final Map<String, Map> mealsData = {};
      for (final meal in meals) {
        mealsData[meal.id] = meal.toJson();
      }
      await _mealBox.putAll(mealsData);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving meals: $e');
      }
    }
  }

  /// Récupère un repas par ID
  Meal? getMeal(String mealId) {
    if (!_isInitialized) return null;
    
    try {
      final mealData = _mealBox.get(mealId);
      return mealData != null ? Meal.fromJson(Map<String, dynamic>.from(mealData)) : null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting meal: $e');
      }
      return null;
    }
  }

  /// Récupère tous les repas stockés
  List<Meal> getAllMeals() {
    if (!_isInitialized) return [];
    
    try {
      return _mealBox.values
          .map((data) => Meal.fromJson(Map<String, dynamic>.from(data)))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting meals: $e');
      }
      return [];
    }
  }

  /// Récupère les repas disponibles
  List<Meal> getAvailableMeals() {
    return getAllMeals().where((meal) => meal.isAvailable).toList();
  }

  /// Récupère les repas d'un commerçant
  List<Meal> getMealsByMerchant(String merchantId) {
    return getAllMeals().where((meal) => meal.merchantId == merchantId).toList();
  }

  /// Supprime un repas
  Future<void> deleteMeal(String mealId) async {
    if (!_isInitialized) return;
    
    try {
      await _mealBox.delete(mealId);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting meal: $e');
      }
    }
  }

  // ==================== ORDER OPERATIONS ====================

  /// Sauvegarde une commande localement
  Future<void> saveOrder(Order order) async {
    if (!_isInitialized) throw Exception('Database not initialized');
    
    try {
      await _orderBox.put(order.id, order.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving order: $e');
      }
      rethrow;
    }
  }

  /// Récupère une commande par ID
  Order? getOrder(String orderId) {
    if (!_isInitialized) return null;
    
    try {
      final orderData = _orderBox.get(orderId);
      return orderData != null ? Order.fromJson(Map<String, dynamic>.from(orderData)) : null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting order: $e');
      }
      return null;
    }
  }

  /// Récupère toutes les commandes
  List<Order> getAllOrders() {
    if (!_isInitialized) return [];
    
    try {
      return _orderBox.values
          .map((data) => Order.fromJson(Map<String, dynamic>.from(data)))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting orders: $e');
      }
      return [];
    }
  }

  /// Récupère les commandes d'un étudiant
  List<Order> getOrdersByStudent(String studentId) {
    return getAllOrders().where((order) => order.studentId == studentId).toList();
  }

  /// Récupère les commandes d'un commerçant
  List<Order> getOrdersByMerchant(String merchantId) {
    return getAllOrders().where((order) => order.merchantId == merchantId).toList();
  }

  /// Supprime une commande
  Future<void> deleteOrder(String orderId) async {
    if (!_isInitialized) return;
    
    try {
      await _orderBox.delete(orderId);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting order: $e');
      }
    }
  }

  // ==================== RESTAURANT OPERATIONS ====================

  /// Sauvegarde un restaurant localement
  Future<void> saveRestaurant(Restaurant restaurant) async {
    if (!_isInitialized) throw Exception('Database not initialized');
    
    try {
      await _restaurantBox.put(restaurant.id, restaurant.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving restaurant: $e');
      }
      rethrow;
    }
  }

  /// Sauvegarde plusieurs restaurants
  Future<void> saveRestaurants(List<Restaurant> restaurants) async {
    if (!_isInitialized) return;
    
    try {
      final Map<String, Map> restaurantsData = {};
      for (final restaurant in restaurants) {
        restaurantsData[restaurant.id] = restaurant.toJson();
      }
      await _restaurantBox.putAll(restaurantsData);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving restaurants: $e');
      }
    }
  }

  /// Récupère un restaurant par ID
  Restaurant? getRestaurant(String restaurantId) {
    if (!_isInitialized) return null;
    
    try {
      final restaurantData = _restaurantBox.get(restaurantId);
      return restaurantData != null ? Restaurant.fromJson(Map<String, dynamic>.from(restaurantData)) : null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting restaurant: $e');
      }
      return null;
    }
  }

  /// Récupère tous les restaurants
  List<Restaurant> getAllRestaurants() {
    if (!_isInitialized) return [];
    
    try {
      return _restaurantBox.values
          .map((data) => Restaurant.fromJson(Map<String, dynamic>.from(data)))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting restaurants: $e');
      }
      return [];
    }
  }

  /// Récupère les restaurants actifs
  List<Restaurant> getActiveRestaurants() {
    return getAllRestaurants().where((restaurant) => restaurant.isActive).toList();
  }

  /// Supprime un restaurant
  Future<void> deleteRestaurant(String restaurantId) async {
    if (!_isInitialized) return;
    
    try {
      await _restaurantBox.delete(restaurantId);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting restaurant: $e');
      }
    }
  }

  // ==================== SETTINGS OPERATIONS ====================

  /// Sauvegarde une préférence
  Future<void> setSetting(String key, String value) async {
    if (!_isInitialized) return;
    
    try {
      await _settingsBox.put(key, value);
    } catch (e) {
      if (kDebugMode) {
        print('Error setting preference: $e');
      }
    }
  }

  /// Récupère une préférence
  String? getSetting(String key) {
    if (!_isInitialized) return null;
    
    try {
      return _settingsBox.get(key);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting preference: $e');
      }
      return null;
    }
  }

  /// Supprime une préférence
  Future<void> removeSetting(String key) async {
    if (!_isInitialized) return;
    
    try {
      await _settingsBox.delete(key);
    } catch (e) {
      if (kDebugMode) {
        print('Error removing preference: $e');
      }
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Récupère la taille totale du cache
  int getTotalCacheSize() {
    if (!_isInitialized) return 0;
    
    return _userBox.length + 
           _mealBox.length + 
           _orderBox.length + 
           _restaurantBox.length +
           _settingsBox.length;
  }

  /// Compresse la base de données
  Future<void> compact() async {
    if (!_isInitialized) return;
    
    try {
      await _userBox.compact();
      await _mealBox.compact();
      await _orderBox.compact();
      await _restaurantBox.compact();
      await _settingsBox.compact();
      
      if (kDebugMode) {
        print('Database compacted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error compacting database: $e');
      }
    }
  }

  /// Effectue une maintenance de la base de données
  Future<void> performMaintenance() async {
    if (!_isInitialized) return;
    
    try {
      // Nettoyer les repas expirés
      final expiredMeals = getAllMeals().where((meal) => meal.isExpired).toList();
      for (final meal in expiredMeals) {
        await deleteMeal(meal.id);
      }
      
      // Compresser la base de données
      await compact();
      
      if (kDebugMode) {
        print('Database maintenance completed');
        print('Removed ${expiredMeals.length} expired meals');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during maintenance: $e');
      }
    }
  }
}

/// Provider Riverpod pour le service de base de données
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});