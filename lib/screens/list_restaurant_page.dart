import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/list_restaurant_model.dart';
import 'package:restaurant_app/provider/list_restaurant_provider.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:restaurant_app/static/restaurant_search_result_state.dart';
import 'package:restaurant_app/widgets/error_message_widget.dart';
import 'package:restaurant_app/widgets/restaurant_card_widget.dart';

class ListRestaurantPage extends StatelessWidget {
  const ListRestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RestaurantListProvider>();
    provider.fetchRestaurantList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              context.read<LocalDatabaseProvider>().loadAllRestaurantValue();
              Navigator.pushNamed(context, '/favorite');
            },
          ),
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: context.read<ThemeProvider>().toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/setting'),
          ),
        ],
      ),
      body: Consumer<RestaurantListProvider>(
        builder: (context, consumer, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: consumer.searchController,
                  decoration: InputDecoration(
                    hintText: "Search restaurants...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        consumer.lastQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => consumer.clearSearch(),
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (query) => consumer.searchRestaurant(query),
                ),
              ),
              Expanded(child: _buildBody(context, consumer)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, RestaurantListProvider provider) {
    if (provider.lastQuery.isNotEmpty) {
      final state = provider.searchState;
      if (state is RestaurantSearchLoadingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is RestaurantSearchLoadedState) {
        return _buildRestaurantList(context, state.data);
      } else if (state is RestaurantSearchErrorState) {
        return ErrorMessageWidget(
          message: state.error,
          onRetry: () => provider.searchRestaurant(),
        );
      }
      return const SizedBox.shrink();
    }

    final state = provider.resultState;
    if (state is RestaurantListLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is RestaurantListLoadedState) {
      return _buildRestaurantList(context, state.data);
    } else if (state is RestaurantListErrorState) {
      return ErrorMessageWidget(
        message: state.error,
        onRetry: () => provider.fetchRestaurantList(),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildRestaurantList(
    BuildContext context,
    List<Restaurant> restaurants,
  ) {
    if (restaurants.isEmpty) {
      return const Center(child: Text("No restaurants found."));
    }
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return RestaurantCard(
          restaurant: restaurant,
          onTap: () {
            context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
              restaurant.id!,
            );
            context.read<LocalDatabaseProvider>().loadAllRestaurantValue();
            Navigator.pushNamed(context, '/detail', arguments: restaurant.id);
          },
        );
      },
    );
  }
}
