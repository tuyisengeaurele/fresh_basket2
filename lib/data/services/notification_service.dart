import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../repositories/notification_repository.dart';
import '../services/firebase_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background FCM messages are handled automatically by the OS
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _fcm = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _repo = NotificationRepository();

  static const _channelId = 'freshbasket_orders';
  static const _channelName = 'FreshBasket Orders';

  Future<void> initialize() async {
    // Request permissions
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Android notification channel
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Notifications about your FreshBasket orders',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Foreground handler
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);

    // App launched from terminated state via notification
    final initial = await _fcm.getInitialMessage();
    if (initial != null) _handleNotificationOpen(initial);

    // Token refresh
    _fcm.onTokenRefresh.listen((token) {
      final uid = FirebaseService.currentUserId;
      if (uid != null) {
        FirebaseService.users.doc(uid).update({'fcmToken': token});
      }
    });
  }

  Future<String?> getToken() => _fcm.getToken();

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          icon: '@drawable/ic_notification',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );

    // Save to Firestore
    final uid = FirebaseService.currentUserId;
    if (uid != null) {
      _repo.saveNotification(
        userId: uid,
        title: notification.title ?? '',
        body: notification.body ?? '',
        type: message.data['type'] ?? '',
        payload: message.data,
      );
    }
  }

  void _handleNotificationOpen(RemoteMessage message) {
    // Navigation is handled by the NotificationProvider via a stream
    _notificationOpenController?.call(message.data);
  }

  static Function(Map<String, dynamic>)? _notificationOpenController;

  static void setNotificationOpenHandler(Function(Map<String, dynamic>) handler) {
    _notificationOpenController = handler;
  }

  void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        _notificationOpenController?.call(data);
      } catch (_) {}
    }
  }

  Future<void> sendOrderNotification({
    required String token,
    required String type,
    required String orderId,
    required String userId,
  }) async {
    String title;
    String body;

    switch (type) {
      case 'ORDER_PLACED':
        title = 'Order Placed Successfully';
        body = 'We are preparing your fresh produce. Track it live.';
        break;
      case 'ORDER_DISPATCHED':
        title = 'Your Order is On Its Way';
        body = 'A driver is heading to your delivery address. Track in real time.';
        break;
      case 'ORDER_DELIVERED':
        title = 'Order Delivered';
        body = 'Your fresh produce has arrived. Enjoy and leave a review!';
        break;
      default:
        title = 'FreshBasket Update';
        body = 'You have a new update from FreshBasket.';
    }

    await _repo.saveNotification(
      userId: userId,
      title: title,
      body: body,
      type: type,
      payload: {'orderId': orderId, 'type': type},
    );
  }
}
