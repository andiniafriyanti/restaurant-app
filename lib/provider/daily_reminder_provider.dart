import 'package:flutter/material.dart';
import 'package:restaurant_app/data/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyReminderProvider extends ChangeNotifier {
  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;

  DailyReminderProvider() {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool('daily_reminder') ?? false;

    await NotificationService.cancelAll();
    if (_isEnabled) {
      await NotificationService.showScheduledNotification();
    }

    notifyListeners();
  }

  Future<void> toggleReminder(bool value) async {
    _isEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);

    if (value) {
      await NotificationService.requestPermissions();
      await NotificationService.showScheduledNotification();
    } else {
      await NotificationService.cancelAll();
    }

    notifyListeners();
  }
}
