import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../controllers/notification_controller.dart';

/// Écran pour afficher toutes les notifications
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationState = ref.watch(notificationControllerProvider);
    final notificationController = ref.read(notificationControllerProvider.notifier);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          if (notificationState.notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: theme.colorScheme.onSurface,
              ),
              itemBuilder: (context) => [
                if (notificationState.unreadCount > 0)
                  const PopupMenuItem(
                    value: 'mark_all_read',
                    child: Row(
                      children: [
                        Icon(Icons.done_all, size: 20),
                        SizedBox(width: 12),
                        Text('Tout marquer comme lu'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all, size: 20),
                      SizedBox(width: 12),
                      Text('Effacer tout'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'mark_all_read') {
                  notificationController.markAllAsRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Toutes les notifications ont été marquées comme lues'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (value == 'clear_all') {
                  _showClearAllDialog(context, notificationController);
                }
              },
            ),
        ],
      ),
      body: notificationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationState.notifications.isEmpty
              ? _buildEmptyState(theme)
              : _buildNotificationsList(
                  context,
                  theme,
                  notificationState,
                  notificationController,
                ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune notification',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous recevrez ici les mises à jour\nsur vos commandes et offres',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    ThemeData theme,
    NotificationState state,
    NotificationController controller,
  ) {
    // Grouper les notifications par date
    final groupedNotifications = _groupNotificationsByDate(state.notifications);

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: groupedNotifications.length,
      itemBuilder: (context, index) {
        final group = groupedNotifications[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                group['date'] as String,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Liste des notifications pour cette date
            ...((group['notifications'] as List<InAppNotification>).map(
              (notification) => _buildNotificationTile(
                context,
                theme,
                notification,
                controller,
              ),
            )),
            if (index < groupedNotifications.length - 1)
              const Divider(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    ThemeData theme,
    InAppNotification notification,
    NotificationController controller,
  ) {
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Supprimer la notification'),
            content: const Text('Voulez-vous vraiment supprimer cette notification ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Supprimer',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        controller.removeNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification supprimée'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: InkWell(
        onTap: () => controller.handleNotificationTap(context, notification),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isUnread
                ? theme.colorScheme.primary.withOpacity(0.05)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUnread
                  ? theme.colorScheme.primary.withOpacity(0.2)
                  : theme.colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Contenu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: isUnread
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(notification.timestamp),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          if (notification.actionRoute != null)
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: theme.colorScheme.onSurface.withOpacity(0.3),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _groupNotificationsByDate(
    List<InAppNotification> notifications,
  ) {
    final Map<String, List<InAppNotification>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final notification in notifications) {
      final date = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );

      String dateKey;
      if (date == today) {
        dateKey = "Aujourd'hui";
      } else if (date == yesterday) {
        dateKey = "Hier";
      } else {
        dateKey = DateFormat('d MMMM yyyy', 'fr_FR').format(date);
      }

      grouped[dateKey] ??= [];
      grouped[dateKey]!.add(notification);
    }

    return grouped.entries
        .map((e) => {'date': e.key, 'notifications': e.value})
        .toList();
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "À l'instant";
    } else if (difference.inMinutes < 60) {
      return "Il y a ${difference.inMinutes} min";
    } else if (difference.inHours < 24) {
      return "Il y a ${difference.inHours}h";
    } else {
      return DateFormat('HH:mm').format(timestamp);
    }
  }

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

  void _showClearAllDialog(
    BuildContext context,
    NotificationController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer toutes les notifications'),
        content: const Text(
          'Cette action est irréversible. Voulez-vous vraiment supprimer toutes les notifications ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              controller.clearAll();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Toutes les notifications ont été supprimées'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Effacer tout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}