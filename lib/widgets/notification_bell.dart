import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/notification_controller.dart';

/// Widget pour afficher l'icône de notification avec badge
class NotificationBell extends ConsumerWidget {
  const NotificationBell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return IconButton(
      icon: Stack(
        children: [
          Icon(
            Icons.notifications_outlined,
            color: theme.colorScheme.onSurface,
          ),
          if (unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 1.5,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: TextStyle(
                    color: theme.colorScheme.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      onPressed: () {
        context.push('/notifications');
      },
    );
  }
}

/// Widget pour afficher un badge de notification sur un BottomNavigationBarItem
class NotificationBadge extends ConsumerWidget {
  final Widget child;
  final bool showBadge;
  final int? count;

  const NotificationBadge({
    Key? key,
    required this.child,
    this.showBadge = true,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unreadCount = count ?? ref.watch(unreadNotificationCountProvider);
    final shouldShow = showBadge && (unreadCount ?? 0) > 0;

    return Stack(
      children: [
        child,
        if (shouldShow)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Center(
                child: Text(
                  (unreadCount ?? 0) > 9 ? '9+' : unreadCount.toString(),
                  style: TextStyle(
                    color: theme.colorScheme.onError,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Extension pour afficher facilement des notifications in-app
extension NotificationExtension on BuildContext {
  /// Affiche une notification in-app
  void showNotification({
    required String title,
    required String body,
    NotificationType type = NotificationType.system,
    String? actionRoute,
  }) {
    final ref = ProviderScope.containerOf(this);
    final controller = ref.read(notificationControllerProvider.notifier);
    
    controller.showInAppNotification(
      this,
      title: title,
      body: body,
      type: type,
      actionRoute: actionRoute,
    );
  }
  
  /// Affiche une notification de succès
  void showSuccessNotification(String message) {
    showNotification(
      title: '✅ Succès',
      body: message,
      type: NotificationType.system,
    );
  }
  
  /// Affiche une notification d'erreur
  void showErrorNotification(String message) {
    showNotification(
      title: '❌ Erreur',
      body: message,
      type: NotificationType.system,
    );
  }
  
  /// Affiche une notification d'information
  void showInfoNotification(String message) {
    showNotification(
      title: 'ℹ️ Information',
      body: message,
      type: NotificationType.system,
    );
  }
}