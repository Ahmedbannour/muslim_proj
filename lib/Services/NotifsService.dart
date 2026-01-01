import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
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

    final box = Hive.box('muslim_proj');

    /// 🎵 Son par défaut
    String notifSong = "tounsi_ali_burak";

    if (box.get('adhanAuteurId') != null) {
      notifSong = box.get('adhanAuteurId');
    }

    /// 🔥 CHANNEL DYNAMIQUE (IMPORTANT)
    final String channelId = 'adhan_channel_$notifSong';

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Prayer Adhan',
          channelDescription: 'Adhan sound notification',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          sound: RawResourceAndroidNotificationSound(
            notifSong, // 🔥 DYNAMIQUE
          ),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }



  Future<void> cancelAll() async {
    await notificationsPlugin.cancelAll();
  }

}
