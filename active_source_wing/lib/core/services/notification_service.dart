import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../infrastructure/wing_logger.dart';

/// خدمة الإشعارات المحلية داخل التطبيق.
class NotificationService {
  /// Plugin instance.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _nextNotificationId = 1;
  bool _initialized = false;

  /// يتم استدعاؤها عند ضغط المستخدم على إشعار.
  void Function(String? payload)? onNotificationTap;

  /// هل تمت تهيئة الخدمة بنجاح؟
  bool get isInitialized => _initialized;

  /// Initializes the notification service.
  Future<void> init() async {
    if (_initialized) return;

    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    try {
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (response) async {
          onNotificationTap?.call(response.payload);
        },
      );
      _initialized = true;
    } catch (e) {
      WingLogger.warning(
        'تعذر تهيئة خدمة الإشعارات؛ ستستمر بقية وظائف التطبيق.',
        tag: 'Notifications',
        data: {'error': e.toString()},
      );
    }
  }

  /// Shows a notification with the given [title] and [body].
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await init();
    if (!_initialized) return;

    try {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (e) {
      WingLogger.warning(
        'تعذر طلب إذن الإشعارات؛ سيبقى الحفظ المحلي متاحاً.',
        tag: 'Notifications',
        data: {'error_type': e.runtimeType.toString()},
      );
    }

    const androidDetails = AndroidNotificationDetails(
      'nostalgia_wing_events',
      'أحداث جناح الحنين',
      channelDescription: 'إشعارات الذكريات والمفاجآت المحلية',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = _nextNotificationId++;
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Cancels all scheduled notifications.
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Cancels a specific notification by [id].
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
