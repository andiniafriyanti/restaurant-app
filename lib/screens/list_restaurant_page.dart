import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/list_restaurant_provider.dart';
import '../static/restaurant_list_result_state.dart';
import '../widgets/restaurant_card_widget.dart';

class ListRestaurantPage extends StatefulWidget {
  const ListRestaurantPage({super.key});

  @override
  State<ListRestaurantPage> createState() => _ListRestaurantPageState();
}

class _ListRestaurantPageState extends State<ListRestaurantPage> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantListProvider>().fetchRestaurantList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant List")),
      body: Consumer<RestaurantListProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantListLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            RestaurantListLoadedState(data: var restaurantList) =>
              ListView.builder(
                itemCount: restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.pushNamed(context, '/detail');
                    },
                  );
                },
              ),
            RestaurantListErrorState(error: var message) => Center(
              child: Text(message),
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
