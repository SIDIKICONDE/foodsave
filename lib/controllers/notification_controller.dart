import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

/// Modèle pour une notification in-app
class InAppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? actionRoute;
  final Map<String, dynamic>? data;

  InAppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionRoute,
    this.data,
  });

  InAppNotification copyWith({
    bool? isRead,
  }) {
    return InAppNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute,
      data: data,
    );
  }
}

/// Types de notifications
enum NotificationType {
  order,
  meal,
  promotion,
  reminder,
  environmental,
  system,
}

/// État pour gérer les notifications in-app
class NotificationState {
  final List<InAppNotification> notifications;
  final int unreadCount;
  final bool hasPermission;
  final bool isLoading;

  NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.hasPermission = false,
    this.isLoading = false,
  });

  NotificationState copyWith({
    List<InAppNotification>? notifications,
    int? unreadCount,
    bool? hasPermission,
    bool? isLoading,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      hasPermission: hasPermission ?? this.hasPermission,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Controller pour gérer les notifications
class NotificationController extends StateNotifier<NotificationState> {
  final NotificationService _service;
  final Ref _ref;

  NotificationController(this._service, this._ref) : super(NotificationState()) {
    _initialize();
  }

  /// Initialise le controller et le service
  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    
    await _service.initialize();
    
    // Charger les notifications existantes (depuis le cache ou l'API)
    await _loadNotifications();
    
    // Simuler quelques notifications pour la démo
    _addDemoNotifications();
    
    state = state.copyWith(
      isLoading: false,
      hasPermission: true, // Pour la démo
    );
  }

  /// Charge les notifications depuis le stockage ou l'API
  Future<void> _loadNotifications() async {
    // TODO: Charger depuis Supabase ou le cache local
    // Pour l'instant, on utilise une liste vide
  }

  /// Ajoute des notifications de démonstration
  void _addDemoNotifications() {
    final now = DateTime.now();
    
    final demoNotifications = [
      InAppNotification(
        id: '1',
        title: '📦 Nouvelle commande !',
        body: 'Marie Dupont a commandé 2x Sandwich au poulet',
        type: NotificationType.order,
        timestamp: now.subtract(const Duration(minutes: 5)),
        actionRoute: '/merchant/orders',
        data: {'orderId': 'ORD001'},
      ),
      InAppNotification(
        id: '2',
        title: '✅ Commande confirmée',
        body: 'Votre commande chez Le Petit Café est confirmée',
        type: NotificationType.order,
        timestamp: now.subtract(const Duration(minutes: 30)),
        isRead: true,
        actionRoute: '/student/reservation',
        data: {'orderId': 'ORD002'},
      ),
      InAppNotification(
        id: '3',
        title: '🎉 Promotion du jour',
        body: '-50% sur tous les desserts chez Boulangerie Artisanale',
        type: NotificationType.promotion,
        timestamp: now.subtract(const Duration(hours: 1)),
        actionRoute: '/explore',
      ),
      InAppNotification(
        id: '4',
        title: '🌱 Impact environnemental',
        body: 'Vous avez sauvé 10 repas ce mois ! Bravo !',
        type: NotificationType.environmental,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: true,
        actionRoute: '/profile',
      ),
    ];

    state = state.copyWith(
      notifications: demoNotifications,
      unreadCount: demoNotifications.where((n) => !n.isRead).length,
    );
  }

  /// Ajoute une nouvelle notification in-app
  void addNotification(InAppNotification notification) {
    final updatedList = [notification, ...state.notifications];
    state = state.copyWith(
      notifications: updatedList,
      unreadCount: updatedList.where((n) => !n.isRead).length,
    );
  }

  /// Marque une notification comme lue
  void markAsRead(String notificationId) {
    final updatedList = state.notifications.map((n) {
      if (n.id == notificationId && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    state = state.copyWith(
      notifications: updatedList,
      unreadCount: updatedList.where((n) => !n.isRead).length,
    );
  }

  /// Marque toutes les notifications comme lues
  void markAllAsRead() {
    final updatedList = state.notifications.map((n) {
      if (!n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    state = state.copyWith(
      notifications: updatedList,
      unreadCount: 0,
    );
  }

  /// Supprime une notification
  void removeNotification(String notificationId) {
    final updatedList = state.notifications
        .where((n) => n.id != notificationId)
        .toList();

    state = state.copyWith(
      notifications: updatedList,
      unreadCount: updatedList.where((n) => !n.isRead).length,
    );
  }

  /// Efface toutes les notifications
  void clearAll() {
    state = state.copyWith(
      notifications: [],
      unreadCount: 0,
    );
  }

  /// Gère le tap sur une notification
  void handleNotificationTap(BuildContext context, InAppNotification notification) {
    // Marquer comme lue
    markAsRead(notification.id);

    // Naviguer si nécessaire
    if (notification.actionRoute != null) {
      Navigator.pushNamed(
        context,
        notification.actionRoute!,
        arguments: notification.data,
      );
    }
  }

  /// Affiche une notification toast/snackbar
  void showInAppNotification(
    BuildContext context, {
    required String title,
    required String body,
    NotificationType type = NotificationType.system,
    String? actionRoute,
  }) {
    // Créer une nouvelle notification
    final notification = InAppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
      actionRoute: actionRoute,
    );

    // L'ajouter à la liste
    addNotification(notification);

    // Afficher un SnackBar ou un toast
    _showNotificationSnackBar(context, notification);
  }

  /// Affiche un SnackBar pour une notification
  void _showNotificationSnackBar(BuildContext context, InAppNotification notification) {
    final theme = Theme.of(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        backgroundColor: theme.colorScheme.surface,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        content: InkWell(
          onTap: notification.actionRoute != null
              ? () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  handleNotificationTap(context, notification);
                }
              : null,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type)
                      .withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notification.body,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (notification.actionRoute != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ],
          ),
        ),
        action: SnackBarAction(
          label: 'Fermer',
          textColor: theme.colorScheme.onSurface.withOpacity(0.7),
          onPressed: () {},
        ),
      ),
    );
  }

  /// Retourne la couleur selon le type de notification
  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Colors.blue;
      case NotificationType.meal:
        return Colors.orange;
      case NotificationType.promotion:
        return Colors.purple;
      case NotificationType.reminder:
        return Colors.amber;
      case NotificationType.environmental:
        return Colors.green;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  /// Retourne l'icône selon le type de notification
  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.shopping_bag;
      case NotificationType.meal:
        return Icons.restaurant;
      case NotificationType.promotion:
        return Icons.local_offer;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.environmental:
        return Icons.eco;
      case NotificationType.system:
        return Icons.info;
    }
  }

  /// Méthodes pour déclencher des notifications spécifiques

  /// Notifie d'une nouvelle commande
  Future<void> notifyNewOrder(
    BuildContext context, {
    required String orderId,
    required String studentName,
    required String mealTitle,
    required int quantity,
  }) async {
    // Notification push
    await _service.notifyNewOrder(
      orderId: orderId,
      studentName: studentName,
      mealTitle: mealTitle,
      quantity: quantity,
    );

    // Notification in-app
    showInAppNotification(
      context,
      title: '📦 Nouvelle commande !',
      body: '$studentName a commandé ${quantity}x $mealTitle',
      type: NotificationType.order,
      actionRoute: '/merchant/orders',
    );
  }

  /// Notifie de la confirmation d'une commande
  Future<void> notifyOrderConfirmed(
    BuildContext context, {
    required String orderId,
    required String restaurantName,
    required String mealTitle,
  }) async {
    // Notification push
    await _service.notifyOrderConfirmed(
      orderId: orderId,
      restaurantName: restaurantName,
      mealTitle: mealTitle,
    );

    // Notification in-app
    showInAppNotification(
      context,
      title: '✅ Commande confirmée !',
      body: 'Votre commande "$mealTitle" chez $restaurantName a été confirmée',
      type: NotificationType.order,
      actionRoute: '/student/reservation',
    );
  }

  /// Notifie que la commande est prête
  Future<void> notifyOrderReady(
    BuildContext context, {
    required String orderId,
    required String restaurantName,
    required String pickupCode,
  }) async {
    // Notification push
    await _service.notifyOrderReady(
      orderId: orderId,
      restaurantName: restaurantName,
      pickupCode: pickupCode,
    );

    // Notification in-app
    showInAppNotification(
      context,
      title: '🍽️ Commande prête !',
      body: 'Votre commande chez $restaurantName est prête. Code: $pickupCode',
      type: NotificationType.order,
      actionRoute: '/student/reservation',
    );
  }
}

/// Provider pour le NotificationController
final notificationControllerProvider = 
    StateNotifierProvider<NotificationController, NotificationState>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return NotificationController(service, ref);
});

/// Provider pour le nombre de notifications non lues
final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationControllerProvider).unreadCount;
});

/// Provider pour vérifier si l'utilisateur a des notifications
final hasNotificationsProvider = Provider<bool>((ref) {
  return ref.watch(notificationControllerProvider).notifications.isNotEmpty;
});