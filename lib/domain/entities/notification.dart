import 'package:equatable/equatable.dart';

/// Énumération des types de notification.
enum NotificationType {
  /// Nouveau panier disponible.
  newBasketAvailable,
  /// Réservation confirmée.
  reservationConfirmed,
  /// Panier prêt à récupérer.
  basketReady,
  /// Rappel de récupération.
  pickupReminder,
  /// Panier bientôt expiré.
  basketExpiringSoon,
  /// Réservation annulée.
  reservationCancelled,
  /// Nouveau message du commerce.
  commerceMessage,
  /// Nouveau badge ou récompense.
  newBadgeEarned,
  /// Points de fidélité gagnés.
  loyaltyPointsEarned,
  /// Offre spéciale disponible.
  specialOfferAvailable,
  /// Promotion personnalisée.
  personalizedPromo,
  /// Rappel d'évaluation.
  reviewReminder,
  /// Mise à jour de l'application.
  appUpdate,
  /// Maintenance programmée.
  scheduledMaintenance,
  /// Message système.
  systemMessage,
}

/// Énumération de la priorité des notifications.
enum NotificationPriority {
  /// Priorité faible.
  low,
  /// Priorité normale.
  normal,
  /// Priorité élevée.
  high,
  /// Priorité critique (urgent).
  critical,
}

/// Entité représentant une notification utilisateur.
/// 
/// Cette entité gère toutes les notifications envoyées aux utilisateurs,
/// incluant les notifications push, in-app et par email.
class AppNotification extends Equatable {
  /// Crée une nouvelle instance de [AppNotification].
  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.priority,
    this.isRead = false,
    this.readAt,
    this.data = const {},
    this.imageUrl,
    this.actionUrl,
    this.actionText,
    this.expiresAt,
    this.category,
    this.tags = const [],
    this.sentVia = const [],
    this.isActionable = false,
    this.groupId,
    this.relatedEntityId,
    this.relatedEntityType,
  });

  /// Identifiant unique de la notification.
  final String id;

  /// Identifiant de l'utilisateur destinataire.
  final String userId;

  /// Type de notification.
  final NotificationType type;

  /// Titre de la notification.
  final String title;

  /// Message de la notification.
  final String message;

  /// Date et heure de création.
  final DateTime createdAt;

  /// Priorité de la notification.
  final NotificationPriority priority;

  /// Si la notification a été lue.
  final bool isRead;

  /// Date et heure de lecture.
  final DateTime? readAt;

  /// Données additionnelles (JSON).
  final Map<String, dynamic> data;

  /// URL de l'image associée.
  final String? imageUrl;

  /// URL d'action (deep link).
  final String? actionUrl;

  /// Texte du bouton d'action.
  final String? actionText;

  /// Date d'expiration de la notification.
  final DateTime? expiresAt;

  /// Catégorie pour regroupement.
  final String? category;

  /// Tags pour filtrage.
  final List<String> tags;

  /// Canaux par lesquels la notification a été envoyée.
  final List<String> sentVia;

  /// Si la notification nécessite une action.
  final bool isActionable;

  /// ID de groupe pour notifications liées.
  final String? groupId;

  /// ID de l'entité liée.
  final String? relatedEntityId;

  /// Type de l'entité liée.
  final String? relatedEntityType;

  /// Vérifie si la notification est expirée.
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Calcule l'âge de la notification en heures.
  int get ageInHours {
    final Duration age = DateTime.now().difference(createdAt);
    return age.inHours;
  }

  /// Vérifie si la notification est récente (moins de 24h).
  bool get isRecent {
    return ageInHours < 24;
  }

  /// Retourne la couleur selon la priorité.
  String get priorityColor {
    switch (priority) {
      case NotificationPriority.low:
        return '#ADB5BD';
      case NotificationPriority.normal:
        return '#74C0FC';
      case NotificationPriority.high:
        return '#FFD93D';
      case NotificationPriority.critical:
        return '#FF6B6B';
    }
  }

  /// Retourne l'icône selon le type.
  String get typeIcon {
    switch (type) {
      case NotificationType.newBasketAvailable:
        return '🛍️';
      case NotificationType.reservationConfirmed:
        return '✅';
      case NotificationType.basketReady:
        return '📦';
      case NotificationType.pickupReminder:
        return '⏰';
      case NotificationType.basketExpiringSoon:
        return '⚠️';
      case NotificationType.reservationCancelled:
        return '❌';
      case NotificationType.commerceMessage:
        return '💬';
      case NotificationType.newBadgeEarned:
        return '🏆';
      case NotificationType.loyaltyPointsEarned:
        return '⭐';
      case NotificationType.specialOfferAvailable:
        return '🎉';
      case NotificationType.personalizedPromo:
        return '🎯';
      case NotificationType.reviewReminder:
        return '📝';
      case NotificationType.appUpdate:
        return '🔄';
      case NotificationType.scheduledMaintenance:
        return '🔧';
      case NotificationType.systemMessage:
        return 'ℹ️';
    }
  }

  /// Retourne le texte du type localisé.
  String get typeText {
    switch (type) {
      case NotificationType.newBasketAvailable:
        return 'Nouveau panier';
      case NotificationType.reservationConfirmed:
        return 'Réservation confirmée';
      case NotificationType.basketReady:
        return 'Panier prêt';
      case NotificationType.pickupReminder:
        return 'Rappel récupération';
      case NotificationType.basketExpiringSoon:
        return 'Panier expirant';
      case NotificationType.reservationCancelled:
        return 'Réservation annulée';
      case NotificationType.commerceMessage:
        return 'Message commerce';
      case NotificationType.newBadgeEarned:
        return 'Nouveau badge';
      case NotificationType.loyaltyPointsEarned:
        return 'Points gagnés';
      case NotificationType.specialOfferAvailable:
        return 'Offre spéciale';
      case NotificationType.personalizedPromo:
        return 'Promotion personnalisée';
      case NotificationType.reviewReminder:
        return 'Rappel évaluation';
      case NotificationType.appUpdate:
        return 'Mise à jour';
      case NotificationType.scheduledMaintenance:
        return 'Maintenance';
      case NotificationType.systemMessage:
        return 'Message système';
    }
  }

  /// Retourne le texte de priorité.
  String get priorityText {
    switch (priority) {
      case NotificationPriority.low:
        return 'Faible';
      case NotificationPriority.normal:
        return 'Normale';
      case NotificationPriority.high:
        return 'Élevée';
      case NotificationPriority.critical:
        return 'Critique';
    }
  }

  /// Formate l'âge de la notification.
  String get formattedAge {
    final int hours = ageInHours;
    if (hours < 1) {
      final int minutes = DateTime.now().difference(createdAt).inMinutes;
      return minutes <= 1 ? 'À l\'instant' : '${minutes}min';
    } else if (hours < 24) {
      return '${hours}h';
    } else {
      final int days = hours ~/ 24;
      return '${days}j';
    }
  }

  /// Crée une copie de la notification avec des valeurs modifiées.
  AppNotification copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? createdAt,
    NotificationPriority? priority,
    bool? isRead,
    DateTime? readAt,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    String? actionText,
    DateTime? expiresAt,
    String? category,
    List<String>? tags,
    List<String>? sentVia,
    bool? isActionable,
    String? groupId,
    String? relatedEntityId,
    String? relatedEntityType,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      actionText: actionText ?? this.actionText,
      expiresAt: expiresAt ?? this.expiresAt,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      sentVia: sentVia ?? this.sentVia,
      isActionable: isActionable ?? this.isActionable,
      groupId: groupId ?? this.groupId,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      relatedEntityType: relatedEntityType ?? this.relatedEntityType,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        message,
        createdAt,
        priority,
        isRead,
        readAt,
        data,
        imageUrl,
        actionUrl,
        actionText,
        expiresAt,
        category,
        tags,
        sentVia,
        isActionable,
        groupId,
        relatedEntityId,
        relatedEntityType,
      ];

  @override
  String toString() {
    return 'AppNotification(id: $id, type: $type, title: $title, isRead: $isRead)';
  }
}