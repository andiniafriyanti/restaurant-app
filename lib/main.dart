import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/list_restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/screens/list_restaurant_page.dart';

import 'data/services/restaurant_services.dart';
import 'screens/detail_restaurant_page.dart';
import 'style/theme/restaurant_theme.dart';

void main() {
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: RestaurantTheme.lightTheme,
      darkTheme: RestaurantTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const ListRestaurantPage(),
        '/detail': (context) {
          return DetailRestaurantPage(
            restaurantId: ModalRoute.of(context)?.settings.arguments as String,
          );
        },
      },
    );
  }
}
