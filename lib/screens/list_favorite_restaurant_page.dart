import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/local_database_provider.dart';
import '../widgets/restaurant_card_widget.dart';

class ListFavoriteRestaurantPage extends StatefulWidget {
  const ListFavoriteRestaurantPage({super.key});

  @override
  State<ListFavoriteRestaurantPage> createState() =>
      _ListFavoriteRestaurantPageState();
}

class _ListFavoriteRestaurantPageState
    extends State<ListFavoriteRestaurantPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocalDatabaseProvider>().loadAllRestaurantValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Restaurant")),
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, value, child) {
          final favoriteList = value.restaurantList ?? [];
          return switch (favoriteList.isNotEmpty) {
            true => ListView.builder(
              itemCount: favoriteList.length,
              itemBuilder: (context, index) {
                final restaurant = favoriteList[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: restaurant.id,
                    );
                  },
                );
              },
            ),
            _ => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("No Favorite Restaurant")],
              ),
            ),
          };
        },
      ),
    );
  }
}
