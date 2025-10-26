import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/daily_reminder_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider = context.watch<DailyReminderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Restaurant Notification'),
            subtitle: const Text('Enable notification'),
            value: reminderProvider.isEnabled,
            onChanged: (value) {
              reminderProvider.toggleReminder(value);
            },
          ),
        ],
      ),
    );
  }
}
