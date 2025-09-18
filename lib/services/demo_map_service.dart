import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../config/supabase_config.dart';
import '../models/map_marker.dart';
import '../services/maps_service.dart';

/// Service de démonstration pour la carte (sans Supabase)
class DemoMapService {
  /// Service de carte
  final MapsService _mapsService = MapsService();
  
  /// Cache local Hive
  late Box<Map<dynamic, dynamic>> _cacheBox;
  
  /// Timer pour les notifications de proximité
  Timer? _proximityTimer;
  
  /// Dernière position connue
  Position? _lastKnownPosition;

  /// Initialiser le service
  Future<void> initialize() async {
    try {
      // Ouvrir le cache local
      _cacheBox = await Hive.openBox<Map<dynamic, dynamic>>('map_cache');
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation du cache: $e');
    }
    
    // Démarrer le suivi de proximité
    _startProximityTracking();
  }

  /// Récupérer les paniers (version démo avec données fictives)
  Future<List<MapMarker>> fetchBasketsFromSupabase({
    LatLng? center,
    double radiusKm = 10,
  }) async {
    try {
      // Position centrale (par défaut: position actuelle ou Paris)
      final LatLng searchCenter = center ?? 
          (_lastKnownPosition != null 
            ? LatLng(_lastKnownPosition!.latitude, _lastKnownPosition!.longitude)
            : const LatLng(48.8566, 2.3522));

      // Données de démonstration
      final List<MapMarker> demoMarkers = [
        MapMarker(
          id: 'demo_1',
          position: LatLng(searchCenter.latitude + 0.001, searchCenter.longitude + 0.001),
          type: MarkerType.boulangerie,
          title: 'Boulangerie du Coin',
          description: 'Panier surprise avec viennoiseries',
          price: 3.99,
          shopName: 'Au Bon Pain',
          address: '12 Rue de la Paix',
          rating: 4.5,
          quantity: 3,
          availableUntil: DateTime.now().add(const Duration(hours: 2)),
          imageUrl: 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73',
        ),
        MapMarker(
          id: 'demo_2',
          position: LatLng(searchCenter.latitude - 0.002, searchCenter.longitude + 0.003),
          type: MarkerType.restaurant,
          title: 'Plat du jour',
          description: 'Reste de service midi - Cuisine française',
          price: 5.99,
          shopName: 'Le Bistrot',
          address: '45 Avenue Victor Hugo',
          rating: 4.2,
          quantity: 2,
          availableUntil: DateTime.now().add(const Duration(hours: 1)),
        ),
        MapMarker(
          id: 'demo_3',
          position: LatLng(searchCenter.latitude + 0.003, searchCenter.longitude - 0.001),
          type: MarkerType.supermarche,
          title: 'Panier légumes',
          description: 'Légumes proches de la date limite',
          price: 2.99,
          shopName: 'Carrefour City',
          address: '78 Boulevard Saint-Michel',
          rating: 3.8,
          quantity: 5,
          availableUntil: DateTime.now().add(const Duration(hours: 4)),
          imageUrl: 'https://images.unsplash.com/photo-1488459716781-31db52582fe9',
        ),
        MapMarker(
          id: 'demo_4',
          position: LatLng(searchCenter.latitude - 0.001, searchCenter.longitude - 0.002),
          type: MarkerType.primeur,
          title: 'Fruits de saison',
          description: 'Assortiment de fruits mûrs',
          price: 4.50,
          shopName: 'Primeur Martin',
          address: '23 Rue de Rivoli',
          rating: 4.7,
          quantity: 4,
          availableUntil: DateTime.now().add(const Duration(hours: 3)),
        ),
        MapMarker(
          id: 'demo_5',
          position: LatLng(searchCenter.latitude + 0.002, searchCenter.longitude + 0.002),
          type: MarkerType.autre,
          title: 'Box surprise',
          description: 'Produits variés à découvrir',
          price: 6.99,
          shopName: 'Épicerie Fine',
          address: '90 Rue du Faubourg Saint-Antoine',
          rating: 4.0,
          quantity: 1,
          availableUntil: DateTime.now().add(const Duration(minutes: 45)),
        ),
      ];

      // Filtrer par rayon
      final List<MapMarker> filteredMarkers = demoMarkers.where((marker) {
        final double distance = Geolocator.distanceBetween(
          searchCenter.latitude,
          searchCenter.longitude,
          marker.position.latitude,
          marker.position.longitude,
        ) / 1000; // Convertir en km
        
        return distance <= radiusKm;
      }).toList();

      // Mettre à jour le cache
      await _saveToCache(filteredMarkers);
      
      // Ajouter les marqueurs au service de carte
      _mapsService.clearMarkers();
      _mapsService.addMarkers(filteredMarkers);

      return filteredMarkers;
    } catch (e) {
      debugPrint('Erreur lors de la récupération des paniers: $e');
      // Essayer de charger depuis le cache en cas d'erreur
      return await _loadFromCache();
    }
  }

  /// Rechercher des paniers par requête (version démo)
  Future<List<MapMarker>> searchBaskets(String query) async {
    try {
      // Pour la démo, on filtre simplement les marqueurs existants
      final allMarkers = await fetchBasketsFromSupabase();
      
      final List<MapMarker> filteredMarkers = allMarkers.where((marker) {
        final String searchText = '${marker.title} ${marker.description} ${marker.shopName ?? ''}'.toLowerCase();
        return searchText.contains(query.toLowerCase());
      }).toList();

      return filteredMarkers;
    } catch (e) {
      debugPrint('Erreur lors de la recherche: $e');
      return [];
    }
  }

  /// Basculer un panier en favori (version démo)
  Future<bool> toggleFavorite(String basketId) async {
    try {
      // Pour la démo, on simule juste un changement d'état
      final marker = _mapsService.markers[basketId];
      if (marker != null) {
        final updatedMarker = marker.copyWith(isFavorite: !marker.isFavorite);
        _mapsService.addMarker(updatedMarker);
        return updatedMarker.isFavorite;
      }
      return false;
    } catch (e) {
      debugPrint('Erreur lors de la gestion des favoris: $e');
      return false;
    }
  }

  /// Sauvegarder dans le cache local
  Future<void> _saveToCache(List<MapMarker> markers) async {
    try {
      final Map<String, Map<String, dynamic>> cacheData = {};
      
      for (final marker in markers.take(SupabaseConfig.maxCachedBaskets)) {
        cacheData[marker.id] = {
          'id': marker.id,
          'latitude': marker.position.latitude,
          'longitude': marker.position.longitude,
          'type': marker.type.name,
          'title': marker.title,
          'description': marker.description,
          'price': marker.price,
          'imageUrl': marker.imageUrl,
          'quantity': marker.quantity,
          'availableUntil': marker.availableUntil?.toIso8601String(),
          'rating': marker.rating,
          'shopName': marker.shopName,
          'address': marker.address,
          'isFavorite': marker.isFavorite,
        };
      }

      await _cacheBox.put('baskets', cacheData as Map<dynamic, dynamic>);
      await _cacheBox.put('cache_time', {'timestamp': DateTime.now().toIso8601String()});
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde dans le cache: $e');
    }
  }

  /// Charger depuis le cache local
  Future<List<MapMarker>> _loadFromCache() async {
    try {
      final cacheData = _cacheBox.get('baskets');
      final cacheTimeMap = _cacheBox.get('cache_time');
      final cacheTimeStr = cacheTimeMap?['timestamp'] as String?;

      if (cacheData == null || cacheTimeStr == null) return [];

      // Vérifier la validité du cache
      final cacheTime = DateTime.parse(cacheTimeStr);
      if (DateTime.now().difference(cacheTime) > SupabaseConfig.cacheValidDuration) {
        return [];
      }

      final List<MapMarker> markers = [];
      for (final entry in cacheData.entries) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        markers.add(MapMarker(
          id: data['id'].toString(),
          position: LatLng(
            data['latitude'] as double,
            data['longitude'] as double,
          ),
          type: _getMarkerType(data['type'].toString()),
          title: data['title'].toString(),
          description: data['description'].toString(),
          price: data['price'] as double?,
          imageUrl: data['imageUrl'] as String?,
          quantity: data['quantity'] as int?,
          availableUntil: data['availableUntil'] != null 
            ? DateTime.parse(data['availableUntil'].toString())
            : null,
          rating: data['rating'] as double?,
          shopName: data['shopName'] as String?,
          address: data['address'] as String?,
          isFavorite: data['isFavorite'] as bool? ?? false,
        ));
      }

      // Ajouter les marqueurs au service de carte
      _mapsService.clearMarkers();
      _mapsService.addMarkers(markers);

      return markers;
    } catch (e) {
      debugPrint('Erreur lors du chargement du cache: $e');
      return [];
    }
  }

  /// Démarrer le suivi de proximité
  void _startProximityTracking() {
    _proximityTimer = Timer.periodic(
      Duration(minutes: SupabaseConfig.notificationIntervalMinutes),
      (_) => _checkProximity(),
    );
  }

  /// Vérifier la proximité avec les paniers
  Future<void> _checkProximity() async {
    try {
      final Position position = await Geolocator.getCurrentPosition();
      _lastKnownPosition = position;

      // Pour la démo, on log juste un message
      debugPrint('Vérification de proximité à ${position.latitude}, ${position.longitude}');
    } catch (e) {
      debugPrint('Erreur lors de la vérification de proximité: $e');
    }
  }

  /// Convertir le type de string en enum
  MarkerType _getMarkerType(String type) {
    switch (type.toLowerCase()) {
      case 'boulangerie':
        return MarkerType.boulangerie;
      case 'restaurant':
        return MarkerType.restaurant;
      case 'supermarche':
        return MarkerType.supermarche;
      case 'primeur':
        return MarkerType.primeur;
      default:
        return MarkerType.autre;
    }
  }

  /// Nettoyer les ressources
  void dispose() {
    _proximityTimer?.cancel();
  }
}