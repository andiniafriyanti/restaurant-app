import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';
import 'package:restaurant_app/widgets/restaurant_detail_widget.dart';

class DetailRestaurantPage extends StatelessWidget {
  final String restaurantId;

  const DetailRestaurantPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
      restaurantId,
    );
    context.read<LocalDatabaseProvider>().loadAllRestaurantValue();

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Restaurant'), centerTitle: true),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, child) {
          final state = value.resultState;
          if (state is RestaurantDetailLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestaurantDetailErrorState) {
            return Center(
              child: Text(
                "😴 \n The server is taking a break.\nPlease try again later.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            );
          }

          if (state is RestaurantDetailLoadedState) {
            final restaurant = state.data;
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Hero(
                          tag: 'restaurant-image-${restaurant.id}',
                          child: Image.network(
                            "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId ?? ''}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RestaurantDetail(restaurant: restaurant),
                        ),
                      ),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Hero(
                          tag: 'restaurant-image-${restaurant.id}',
                          child: Image.network(
                            "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId ?? ''}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RestaurantDetail(restaurant: restaurant),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
