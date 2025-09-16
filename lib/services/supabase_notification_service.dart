import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service de notifications push natif intégré avec Supabase
/// Standards NYTH - Zero Compromise
class SupabaseNotificationService {
  static final SupabaseNotificationService _instance =
      SupabaseNotificationService._internal();
  static SupabaseNotificationService get instance => _instance;

  SupabaseNotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  String? _deviceToken;
  Function(Map<String, dynamic>)? onNotificationReceived;
  Function(Map<String, dynamic>)? onNotificationClicked;

  /// Initialise le service de notifications
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Initialiser AwesomeNotifications
      await AwesomeNotifications().initialize(
        null, // Utiliser l'icône par défaut
        [
          NotificationChannel(
            channelGroupKey: 'foodsave_group',
            channelKey: 'foodsave_channel',
            channelName: 'FoodSave Notifications',
            channelDescription: 'Notifications pour les repas et commandes',
            defaultColor: const Color(0xFF4CAF50),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
          ),
          NotificationChannel(
            channelGroupKey: 'foodsave_group',
            channelKey: 'meal_expiry_channel',
            channelName: 'Expiration des repas',
            channelDescription: 'Alertes d\'expiration pour les commerçants',
            defaultColor: const Color(0xFFFF9800),
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            playSound: true,
          ),
          NotificationChannel(
            channelGroupKey: 'foodsave_group',
            channelKey: 'order_updates_channel',
            channelName: 'Mises à jour des commandes',
            channelDescription: 'Statut des commandes en temps réel',
            defaultColor: const Color(0xFF2196F3),
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
          ),
          NotificationChannel(
            channelGroupKey: 'foodsave_group',
            channelKey: 'promotions_channel',
            channelName: 'Promotions et offres',
            channelDescription: 'Nouvelles offres et promotions',
            defaultColor: const Color(0xFF9C27B0),
            importance: NotificationImportance.Default,
            channelShowBadge: true,
            playSound: false,
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: 'foodsave_group',
            channelGroupName: 'FoodSave',
          )
        ],
      );

      // Initialiser Flutter Local Notifications (fallback)
      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationClick,
      );

      // Configurer les listeners
      _setupListeners();

      // Demander les permissions
      await _requestPermissions();

      // Générer un token d'appareil unique
      await _generateDeviceToken();

      _isInitialized = true;
      print('✅ SupabaseNotificationService initialisé avec succès');
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation des notifications: $e');
    }
  }

  /// Configure les listeners de notifications
  void _setupListeners() {
    // Listener pour les notifications reçues
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        final payload = receivedAction.payload ?? {};

        if (receivedAction.actionType == ActionType.Default) {
          // Notification cliquée
          if (onNotificationClicked != null) {
            onNotificationClicked!(payload);
          }
        }
      },
      onNotificationCreatedMethod: (ReceivedNotification notification) async {
        // Notification créée
        if (onNotificationReceived != null) {
          onNotificationReceived!(notification.payload ?? {});
        }
      },
    );

    // Listener pour les mises à jour temps réel Supabase
    _setupSupabaseListeners();
  }

  /// Configure les listeners Supabase pour les notifications temps réel
  void _setupSupabaseListeners() {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId != null) {
      // Écouter les nouvelles notifications
      supabase
          .channel('notifications_$userId')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'notifications',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: userId,
            ),
            callback: (payload) {
              final notification = payload.newRecord;
              _showLocalNotification(
                title: notification['title'] ?? 'FoodSave',
                body: notification['message'] ?? '',
                payload: jsonEncode(notification['data'] ?? {}),
                channelKey: _getChannelKeyForType(notification['type']),
              );
            },
          )
          .subscribe();

      // Écouter les mises à jour de commandes
      supabase
          .channel('orders_$userId')
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'orders',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'customer_id',
              value: userId,
            ),
            callback: (payload) {
              final order = payload.newRecord;
              _showOrderUpdateNotification(order);
            },
          )
          .subscribe();

      // Écouter les nouvelles commandes (pour commerçants)
      supabase
          .channel('merchant_orders_$userId')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'orders',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'merchant_id',
              value: userId,
            ),
            callback: (payload) {
              final order = payload.newRecord;
              _showNewOrderNotification(order);
            },
          )
          .subscribe();
    }
  }

  /// Demande les permissions de notifications
  Future<bool> _requestPermissions() async {
    bool granted = false;

    // AwesomeNotifications permissions
    await AwesomeNotifications().requestPermissionToSendNotifications();
    granted = await AwesomeNotifications().isNotificationAllowed();

    if (!granted) {
      // Fallback avec permission_handler
      final status = await Permission.notification.request();
      granted = status.isGranted;
    }

    if (Platform.isIOS) {
      // Permissions spécifiques iOS
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    print(granted
        ? '✅ Permissions de notifications accordées'
        : '❌ Permissions de notifications refusées');

    return granted;
  }

  /// Génère un token d'appareil unique
  Future<void> _generateDeviceToken() async {
    try {
      // Utiliser l'ID de l'utilisateur + informations de l'appareil
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final platform = Platform.operatingSystem;
      _deviceToken = '${platform}_$timestamp';

      print('📱 Token d\'appareil généré: $_deviceToken');
    } catch (e) {
      print('❌ Erreur lors de la génération du token: $e');
    }
  }

  /// Enregistre le token d'appareil dans Supabase
  Future<void> registerDeviceToken() async {
    if (_deviceToken == null) return;

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId != null) {
        // Créer la table si elle n'existe pas (sera géré par les migrations)
        await supabase.rpc('register_device_token', params: {
          'p_user_id': userId,
          'p_device_token': _deviceToken,
          'p_platform': Platform.operatingSystem,
        });

        print('✅ Token d\'appareil enregistré dans Supabase');
      }
    } catch (e) {
      print('❌ Erreur lors de l\'enregistrement du token: $e');
    }
  }

  /// Affiche une notification locale
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelKey = 'foodsave_channel',
  }) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: channelKey,
          title: title,
          body: body,
          payload: payload != null ? {'data': payload} : null,
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
        ),
      );
    } catch (e) {
      // Fallback avec flutter_local_notifications
      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelKey,
            'FoodSave Notifications',
            channelDescription: 'Notifications FoodSave',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: payload,
      );
    }
  }

  /// Affiche une notification de mise à jour de commande
  Future<void> _showOrderUpdateNotification(Map<String, dynamic> order) async {
    final status = order['status'];
    String title = 'Commande mise à jour';
    String body = '';

    switch (status) {
      case 'confirmed':
        title = '✅ Commande confirmée';
        body = 'Votre commande a été confirmée par le commerçant';
        break;
      case 'preparing':
        title = '👨‍🍳 Préparation en cours';
        body = 'Votre repas est en cours de préparation';
        break;
      case 'ready':
        title = '🎉 Commande prête !';
        body = 'Votre repas est prêt à être récupéré';
        break;
      case 'completed':
        title = '✅ Commande terminée';
        body = 'Merci d\'avoir utilisé FoodSave !';
        break;
      case 'cancelled':
        title = '❌ Commande annulée';
        body = 'Votre commande a été annulée';
        break;
    }

    await _showLocalNotification(
      title: title,
      body: body,
      payload: jsonEncode({
        'type': 'order_update',
        'order_id': order['id'],
        'status': status,
      }),
      channelKey: 'order_updates_channel',
    );
  }

  /// Affiche une notification de nouvelle commande
  Future<void> _showNewOrderNotification(Map<String, dynamic> order) async {
    await _showLocalNotification(
      title: '🛒 Nouvelle commande !',
      body: 'Vous avez reçu une nouvelle commande',
      payload: jsonEncode({
        'type': 'new_order',
        'order_id': order['id'],
      }),
      channelKey: 'order_updates_channel',
    );
  }

  /// Envoie une notification à un utilisateur spécifique
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String message,
    String type = 'general',
    Map<String, dynamic>? data,
  }) async {
    try {
      final supabase = Supabase.instance.client;

      // Insérer la notification dans la base de données
      await supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'message': message,
        'type': type,
        'data': data ?? {},
        'created_at': DateTime.now().toIso8601String(),
      });

      print('✅ Notification envoyée à l\'utilisateur $userId');
    } catch (e) {
      print('❌ Erreur lors de l\'envoi de la notification: $e');
    }
  }

  /// Envoie une notification de repas bientôt expiré
  Future<void> sendMealExpiryNotification({
    required String merchantId,
    required String mealTitle,
    required int remainingQuantity,
    required DateTime expiresAt,
  }) async {
    final hoursLeft = expiresAt.difference(DateTime.now()).inHours;

    await sendNotificationToUser(
      userId: merchantId,
      title: '⏰ Repas bientôt expiré',
      message:
          '$mealTitle expire dans ${hoursLeft}h. $remainingQuantity portion(s) restante(s).',
      type: 'meal_expiring',
      data: {
        'meal_title': mealTitle,
        'remaining_quantity': remainingQuantity,
        'expires_at': expiresAt.toIso8601String(),
        'hours_left': hoursLeft,
      },
    );
  }

  /// Envoie une notification de nouvelle commande
  Future<void> sendNewOrderNotification({
    required String merchantId,
    required String customerName,
    required String mealTitle,
    required int quantity,
    required String orderId,
  }) async {
    await sendNotificationToUser(
      userId: merchantId,
      title: '🛒 Nouvelle commande !',
      message: '$customerName a commandé $quantity x $mealTitle',
      type: 'new_order',
      data: {
        'order_id': orderId,
        'customer_name': customerName,
        'meal_title': mealTitle,
        'quantity': quantity,
      },
    );
  }

  /// Envoie une notification de statut de commande
  Future<void> sendOrderStatusNotification({
    required String customerId,
    required String orderId,
    required String status,
    required String mealTitle,
    String? additionalInfo,
  }) async {
    String title = 'Mise à jour de commande';
    String message = '';

    switch (status) {
      case 'confirmed':
        title = '✅ Commande confirmée';
        message = 'Votre commande "$mealTitle" a été confirmée';
        break;
      case 'preparing':
        title = '👨‍🍳 En préparation';
        message = 'Votre repas "$mealTitle" est en cours de préparation';
        break;
      case 'ready':
        title = '🎉 Commande prête !';
        message = 'Votre repas "$mealTitle" est prêt à être récupéré';
        break;
      case 'completed':
        title = '✅ Commande terminée';
        message = 'Merci d\'avoir utilisé FoodSave !';
        break;
      case 'cancelled':
        title = '❌ Commande annulée';
        message = 'Votre commande "$mealTitle" a été annulée';
        break;
    }

    if (additionalInfo != null) {
      message += '\n$additionalInfo';
    }

    await sendNotificationToUser(
      userId: customerId,
      title: title,
      message: message,
      type: 'order_status',
      data: {
        'order_id': orderId,
        'status': status,
        'meal_title': mealTitle,
      },
    );
  }

  /// Envoie une notification promotionnelle
  Future<void> sendPromotionalNotification({
    required String userId,
    required String title,
    required String message,
    String? imageUrl,
    Map<String, dynamic>? actionData,
  }) async {
    await sendNotificationToUser(
      userId: userId,
      title: title,
      message: message,
      type: 'promotion',
      data: {
        'image_url': imageUrl,
        'action_data': actionData,
      },
    );
  }

  /// Marque une notification comme lue
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase.from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('id', notificationId);
    } catch (e) {
      print('❌ Erreur lors du marquage de notification: $e');
    }
  }

  /// Récupère les notifications non lues d'un utilisateur
  Future<List<Map<String, dynamic>>> getUnreadNotifications(
      String userId) async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('notifications')
          .select('*')
          .eq('user_id', userId)
          .eq('is_read', false)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Erreur lors de la récupération des notifications: $e');
      return [];
    }
  }

  /// Supprime les anciennes notifications
  Future<void> cleanupOldNotifications() async {
    try {
      final supabase = Supabase.instance.client;
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

      await supabase
          .from('notifications')
          .delete()
          .lt('created_at', thirtyDaysAgo.toIso8601String())
          .eq('is_read', true);

      print('✅ Anciennes notifications supprimées');
    } catch (e) {
      print('❌ Erreur lors du nettoyage: $e');
    }
  }

  /// Obtient la clé de canal selon le type de notification
  String _getChannelKeyForType(String type) {
    switch (type) {
      case 'meal_expiring':
      case 'meal_expired':
        return 'meal_expiry_channel';
      case 'order_update':
      case 'order_status':
      case 'new_order':
        return 'order_updates_channel';
      case 'promotion':
        return 'promotions_channel';
      default:
        return 'foodsave_channel';
    }
  }

  /// Handler pour les clics de notifications
  void _onNotificationClick(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        if (onNotificationClicked != null) {
          onNotificationClicked!(data);
        }
      } catch (e) {
        print('❌ Erreur lors du parsing du payload: $e');
      }
    }
  }

  /// Désactive le service
  Future<void> disable() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId != null && _deviceToken != null) {
        await supabase.rpc('deactivate_device_token', params: {
          'p_user_id': userId,
          'p_device_token': _deviceToken,
        });
      }

      await AwesomeNotifications().cancelAll();
      _isInitialized = false;

      print('✅ Service de notifications désactivé');
    } catch (e) {
      print('❌ Erreur lors de la désactivation: $e');
    }
  }

  /// Getters
  bool get isInitialized => _isInitialized;
  String? get deviceToken => _deviceToken;
}
