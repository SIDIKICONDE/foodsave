import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuration Supabase pour l'application FoodSave
class SupabaseConfig {
  // Configuration avec votre Project ID: igbloqlksvbeztcnojqk
  /// URL de votre projet Supabase
  static const String supabaseUrl = 'https://igbloqlksvbeztcnojqk.supabase.co';
  
  /// Clé anonyme publique de votre projet Supabase
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlnYmxvcWxrc3ZiZXp0Y25vanFrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwNTc0MzksImV4cCI6MjA3MzYzMzQzOX0.oNKGS6vJSGRLrzqel1u_Ne-P1Va05AU_f0y45eHIMu8';
  
  /// Référence rapide au client Supabase
  static SupabaseClient get client => Supabase.instance.client;
  
  /// Noms des tables dans Supabase
  static const String tableBasketsMap = 'baskets_map';
  static const String tableShops = 'shops';
  static const String tableFavorites = 'user_favorites';
  static const String tableNotifications = 'proximity_notifications';
  static const String tableSearchHistory = 'search_history';
  
  /// Configuration des notifications de proximité
  static const double proximityRadiusKm = 2.0; // Rayon en kilomètres
  static const int notificationIntervalMinutes = 30;
  
  /// Configuration du cache
  static const Duration cacheValidDuration = Duration(hours: 6);
  static const int maxCachedBaskets = 500;
  
  /// Configuration de la recherche
  static const int searchDebounceMs = 500;
  static const int maxSearchResults = 50;
  static const int maxSearchHistory = 20;
}

/// Structure de la table baskets_map dans Supabase
/// 
/// CREATE TABLE baskets_map (
///   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
///   shop_id UUID REFERENCES shops(id),
///   title VARCHAR(255) NOT NULL,
///   description TEXT,
///   price DECIMAL(10,2) NOT NULL,
///   original_price DECIMAL(10,2),
///   latitude DECIMAL(10,8) NOT NULL,
///   longitude DECIMAL(11,8) NOT NULL,
///   type VARCHAR(50) NOT NULL,
///   quantity INTEGER DEFAULT 1,
///   available_from TIMESTAMP WITH TIME ZONE,
///   available_until TIMESTAMP WITH TIME ZONE NOT NULL,
///   image_url TEXT,
///   is_active BOOLEAN DEFAULT true,
///   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
///   updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
/// );
/// 
/// CREATE TABLE shops (
///   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
///   name VARCHAR(255) NOT NULL,
///   address TEXT NOT NULL,
///   phone VARCHAR(20),
///   email VARCHAR(255),
///   rating DECIMAL(2,1),
///   total_reviews INTEGER DEFAULT 0,
///   opening_hours JSONB,
///   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
/// );
/// 
/// CREATE TABLE user_favorites (
///   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
///   user_id UUID NOT NULL,
///   basket_id UUID REFERENCES baskets_map(id),
///   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
///   UNIQUE(user_id, basket_id)
/// );
/// 
/// CREATE TABLE proximity_notifications (
///   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
///   user_id UUID NOT NULL,
///   basket_id UUID REFERENCES baskets_map(id),
///   distance_km DECIMAL(5,2),
///   notified_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
///   clicked BOOLEAN DEFAULT false
/// );
/// 
/// CREATE TABLE search_history (
///   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
///   user_id UUID NOT NULL,
///   search_query VARCHAR(255) NOT NULL,
///   results_count INTEGER,
///   searched_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
/// );