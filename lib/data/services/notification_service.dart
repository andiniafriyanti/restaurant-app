import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await notifications.initialize(settings);
  }

  static Future<void> showScheduledNotification() async {
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await notifications.zonedSchedule(
      0,
      'Waktunya makan siang!',
      'Jangan lupa makan siang ya',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel_id',
          'Daily Reminder',
          channelDescription: 'Notifikasi pengingat harian',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reminder',
    );
  }

  static Future<void> cancelAll() async {
    await notifications.cancelAll();
  }
}
