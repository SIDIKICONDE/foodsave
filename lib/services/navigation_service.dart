import 'dart:math' as dart_math;
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Service de navigation GPS pour diriger vers les commerces
class NavigationService {
  /// Lancer la navigation vers une destination
  static Future<bool> navigateTo({
    required LatLng destination,
    required String destinationName,
  }) async {
    try {
      await MapsLauncher.launchCoordinates(
        destination.latitude,
        destination.longitude,
        destinationName,
      );
      return true;
    } catch (e) {
      debugPrint('Erreur lors du lancement de la navigation: $e');
      return false;
    }
  }

  /// Afficher les options de navigation
  static Future<void> showNavigationOptions({
    required BuildContext context,
    required LatLng destination,
    required String destinationName,
  }) async {
    await navigateTo(
      destination: destination,
      destinationName: destinationName,
    );
  }

  /// Calculer la distance entre deux points
  static double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // Rayon de la Terre en kilomètres
    
    final double lat1Rad = point1.latitude * (3.141592653589793 / 180);
    final double lat2Rad = point2.latitude * (3.141592653589793 / 180);
    final double deltaLat = (point2.latitude - point1.latitude) * (3.141592653589793 / 180);
    final double deltaLng = (point2.longitude - point1.longitude) * (3.141592653589793 / 180);
    
    final double a = (deltaLat / 2).sin() * (deltaLat / 2).sin() +
        lat1Rad.cos() * lat2Rad.cos() *
        (deltaLng / 2).sin() * (deltaLng / 2).sin();
    
    final double c = 2 * a.sqrt().asin();
    
    return earthRadius * c;
  }

  /// Estimer le temps de trajet (approximatif)
  static Duration estimateTravelTime(
    double distanceKm,
    TravelMode mode,
  ) {
    // Vitesses moyennes approximatives
    double speedKmh;
    switch (mode) {
      case TravelMode.walking:
        speedKmh = 5; // 5 km/h en marchant
        break;
      case TravelMode.cycling:
        speedKmh = 15; // 15 km/h à vélo
        break;
      case TravelMode.driving:
        speedKmh = 30; // 30 km/h en ville (avec traffic)
        break;
      case TravelMode.transit:
        speedKmh = 20; // 20 km/h en transport public
        break;
    }
    
    final double hours = distanceKm / speedKmh;
    final int minutes = (hours * 60).round();
    
    return Duration(minutes: minutes);
  }

  /// Formater la durée en texte lisible
  static String formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '$hours h ${minutes > 0 ? "$minutes min" : ""}';
    } else {
      return '$minutes min';
    }
  }
}

/// Mode de transport
enum TravelMode {
  walking,
  cycling,
  driving,
  transit,
}

/// Extension pour les calculs mathématiques
extension NumberExtension on num {
  double sin() => dart_math.sin(toDouble());
  double cos() => dart_math.cos(toDouble());
  double sqrt() => dart_math.sqrt(toDouble());
  double asin() => dart_math.asin(toDouble());
}
