import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;



class NotifsService {
  static final NotifsService _instance = NotifsService._internal();
  factory NotifsService() => _instance;
  NotifsService._internal();

  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initializeNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSetting = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(initSetting);
    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'muslim_proj_id',
        'Prayer notification',
        channelDescription: 'Prayer Notification channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  Future<void> requestPermissions() async {
    await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    await notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    if (dateTime.isBefore(DateTime.now())) return;

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayers_channel',
          'Prayer Times',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }



  Future<void> schedulePrayerNotifications(
      Map<String, String> timings) async {
    final prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    int id = 100; // éviter conflit d’ID

    for (final p in prayers) {
      final time = timings[p];
      if (time == null) continue;

      final parts = time.split(':');
      final now = DateTime.now();

      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      if (dt.isAfter(DateTime.now())) {
        await notificationsPlugin.zonedSchedule(
          id++,
          '🕌 $p Prayer',
          'It’s time for $p prayer',
          tz.TZDateTime.from(dt, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'prayer_channel',
              'Prayer Notifications',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  Future<void> cancelAll() async {
    await notificationsPlugin.cancelAll();
  }
  
}
