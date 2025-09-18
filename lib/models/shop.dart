import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

/// Modèle représentant un magasin/commerçant
/// 
/// Correspond à la table `shops` dans Supabase.
@JsonSerializable()
class Shop extends Equatable {
  /// Identifiant unique du magasin
  final String id;

  /// Nom du magasin
  final String name;

  /// Adresse complète du magasin
  final String address;

  /// Numéro de téléphone
  final String? phone;

  /// Adresse email
  final String? email;

  /// Note moyenne (sur 5)
  final double? rating;

  /// Nombre total d'avis
  @JsonKey(name: 'total_reviews')
  final int totalReviews;

  /// Horaires d'ouverture (format JSON)
  @JsonKey(name: 'opening_hours')
  final Map<String, dynamic>? openingHours;

  /// Date de création
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Crée une nouvelle instance de [Shop]
  const Shop({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    this.rating,
    this.totalReviews = 0,
    this.openingHours,
    required this.createdAt,
  });

  /// Crée une instance de [Shop] à partir d'un JSON
  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  /// Convertit l'instance en JSON
  Map<String, dynamic> toJson() => _$ShopToJson(this);

  /// Vérifie si le magasin est ouvert actuellement
  bool get isOpenNow {
    if (openingHours == null) return true; // Par défaut ouvert si pas d'horaires

    final DateTime now = DateTime.now();
    final String dayOfWeek = _getDayOfWeek(now.weekday);
    final Map<String, dynamic>? daySchedule = openingHours![dayOfWeek] as Map<String, dynamic>?;

    if (daySchedule == null) return false; // Fermé ce jour-ci

    final String currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final String? openTime = daySchedule['open'] as String?;
    final String? closeTime = daySchedule['close'] as String?;

    if (openTime == null || closeTime == null) return false;

    return _isTimeBetween(currentTime, openTime, closeTime);
  }

  /// Obtient les horaires pour un jour donné
  String getScheduleForDay(int weekday) {
    if (openingHours == null) return 'Horaires non définis';

    final String dayOfWeek = _getDayOfWeek(weekday);
    final Map<String, dynamic>? daySchedule = openingHours![dayOfWeek] as Map<String, dynamic>?;

    if (daySchedule == null) return 'Fermé';

    final String? openTime = daySchedule['open'] as String?;
    final String? closeTime = daySchedule['close'] as String?;

    if (openTime == null || closeTime == null) return 'Fermé';

    return '$openTime - $closeTime';
  }

  /// Obtient le nom du jour en français
  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'lundi';
      case DateTime.tuesday:
        return 'mardi';
      case DateTime.wednesday:
        return 'mercredi';
      case DateTime.thursday:
        return 'jeudi';
      case DateTime.friday:
        return 'vendredi';
      case DateTime.saturday:
        return 'samedi';
      case DateTime.sunday:
        return 'dimanche';
      default:
        return 'inconnu';
    }
  }

  /// Vérifie si l'heure actuelle est entre deux heures données
  bool _isTimeBetween(String current, String start, String end) {
    final int currentMinutes = _timeToMinutes(current);
    final int startMinutes = _timeToMinutes(start);
    final int endMinutes = _timeToMinutes(end);

    // Gérer le cas où l'heure de fermeture est le lendemain
    if (endMinutes < startMinutes) {
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  /// Convertit une heure au format HH:MM en minutes depuis minuit
  int _timeToMinutes(String time) {
    final List<String> parts = time.split(':');
    final int hours = int.parse(parts[0]);
    final int minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  /// Crée une copie de l'instance avec les propriétés modifiées
  Shop copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    double? rating,
    int? totalReviews,
    Map<String, dynamic>? openingHours,
    DateTime? createdAt,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      openingHours: openingHours ?? this.openingHours,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phone,
        email,
        rating,
        totalReviews,
        openingHours,
        createdAt,
      ];

  @override
  String toString() {
    return 'Shop(id: $id, name: $name, rating: $rating, totalReviews: $totalReviews)';
  }
}