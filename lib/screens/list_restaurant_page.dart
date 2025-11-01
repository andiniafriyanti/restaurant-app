import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/list_restaurant_provider.dart';
import '../provider/theme_provider.dart';
import '../static/restaurant_list_result_state.dart';
import '../static/restaurant_search_result_state.dart';
import '../widgets/restaurant_card_widget.dart';

class ListRestaurantPage extends StatefulWidget {
  const ListRestaurantPage({super.key});

  @override
  State<ListRestaurantPage> createState() => _ListRestaurantPageState();
}

class _ListRestaurantPageState extends State<ListRestaurantPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildRestaurantList(List restaurants) {
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
            Navigator.pushNamed(context, '/detail', arguments: restaurant.id);
          },
        );
      },
    );
  }

  Widget buildBody(RestaurantListProvider provider) {
    if (provider.lastQuery.isNotEmpty) {
      final state = provider.searchState;
      if (state is RestaurantSearchLoadingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is RestaurantSearchLoadedState) {
        return buildRestaurantList(state.data);
      } else if (state is RestaurantSearchErrorState) {
        return Center(child: Text(state.error));
      }
      return const SizedBox();
    }

    final state = provider.resultState;
    if (state is RestaurantListLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is RestaurantListLoadedState) {
      return buildRestaurantList(state.data);
    } else if (state is RestaurantListErrorState) {
      return Center(child: Text(state.error));
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorite'),
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
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search restaurants...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        provider.lastQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                provider.clearSearch();
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: provider.searchRestaurant,
                ),
              ),
              Expanded(child: buildBody(provider)),
            ],
          );
        },
      ),
    );
  }
}
