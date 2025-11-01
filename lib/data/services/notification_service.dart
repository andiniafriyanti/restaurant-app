import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    final tzNameRaw = await FlutterTimezone.getLocalTimezone();
    final tzName = _mapToValidTimezone(tzNameRaw.localizedName!.name);
    tz.setLocalLocation(tz.getLocation(tzName));

    if (Platform.isAndroid) {
      if (await Permission.notification.isDenied ||
          await Permission.notification.isPermanentlyDenied) {
        await Permission.notification.request();
      }

      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future<void> showScheduledNotification() async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Reminder',
      channelDescription: 'Notifikasi pengingat harian',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      0,
      'Waktunya makan siang!',
      'Jangan lupa makan siang',
      scheduled,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reminder',
    );
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  static String _mapToValidTimezone(String timezone) {
    switch (timezone) {
      case 'Western Indonesia Time':
        return 'Asia/Jakarta';
      case 'Central Indonesia Time':
        return 'Asia/Makassar';
      case 'Eastern Indonesia Time':
        return 'Asia/Jayapura';
      default:
        return 'Asia/Jakarta';
    }
  }
}
