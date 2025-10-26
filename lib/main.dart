import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/daily_reminder_provider.dart';
import 'package:restaurant_app/provider/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/list_restaurant_provider.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/submit_review_provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/screens/list_favorite_restaurant_page.dart';
import 'package:restaurant_app/screens/list_restaurant_page.dart';
import 'package:restaurant_app/screens/setting_page.dart';

import 'data/services/local_database_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/restaurant_services.dart';
import 'screens/detail_restaurant_page.dart';
import 'style/theme/restaurant_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => RestaurantServices()),
        ChangeNotifierProvider(
          create:
              (context) =>
                  RestaurantListProvider(context.read<RestaurantServices>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  RestaurantDetailProvider(context.read<RestaurantServices>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  ReviewSubmitProvider(context.read<RestaurantServices>()),
        ),
        Provider(create: (context) => LocalDatabaseService()),
        ChangeNotifierProvider(
          create:
              (context) =>
                  LocalDatabaseProvider(context.read<LocalDatabaseService>()),
        ),
        ChangeNotifierProvider(create: (context) => FavoriteIconProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => DailyReminderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'Restaurant App',
      theme: RestaurantTheme.lightTheme,
      darkTheme: RestaurantTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const ListRestaurantPage(),
        '/detail': (context) {
          return DetailRestaurantPage(
            restaurantId: ModalRoute.of(context)?.settings.arguments as String,
          );
        },
        '/favorite': (context) => const ListFavoriteRestaurantPage(),
        '/setting': (context) => const SettingPage(),
      },
    );
  }
}
