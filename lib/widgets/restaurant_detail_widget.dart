import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/widgets/review_dialog_widget.dart';
import '../data/models/detail_restaurant_model.dart';
import '../data/models/list_restaurant_model.dart';
import '../provider/expand_description_provider.dart';
import '../provider/favorite_icon_provider.dart';
import '../provider/local_database_provider.dart';
import '../provider/submit_review_provider.dart';

class RestaurantDetail extends StatefulWidget {
  final DetailRestaurant restaurant;
  final Restaurant? listRestaurant;
  const RestaurantDetail({
    super.key,
    required this.restaurant,
    this.listRestaurant,
  });

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localDatabaseProvider = context.read<LocalDatabaseProvider>();
      final favoriteIconProvider = context.read<FavoriteIconProvider>();

      Future.microtask(() async {
        if (widget.listRestaurant != null &&
            widget.listRestaurant!.id != null) {
          await localDatabaseProvider.loadRestaurantValueById(
            widget.listRestaurant!.id!,
          );
          final value = localDatabaseProvider.checkItemFavorite(
            widget.listRestaurant!.id!,
          );

          favoriteIconProvider.isFavorite = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final expandProvider = context.watch<ExpandDescriptionProvider>();
    final restaurant = widget.restaurant;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                restaurant.name ?? "-",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () async {
                  final localDatabaseProvider =
                      context.read<LocalDatabaseProvider>();
                  final favoriteIconProvider =
                      context.read<FavoriteIconProvider>();
                  final isFavorite = favoriteIconProvider.isFavorite;

                  final restaurantData = Restaurant(
                    id: restaurant.id,
                    name: restaurant.name,
                    description: restaurant.description,
                    pictureId: restaurant.pictureId,
                    city: restaurant.city,
                    rating: restaurant.rating,
                  );

                  if (!isFavorite) {
                    await localDatabaseProvider.saveRestaurantValue(
                      restaurantData,
                    );
                  } else {
                    await localDatabaseProvider.removeRestaurantValueById(
                      restaurantData.id!,
                    );
                  }

                  favoriteIconProvider.isFavorite = !isFavorite;
                  await localDatabaseProvider.loadAllRestaurantValue();
                },
                icon: Icon(
                  context.watch<FavoriteIconProvider>().isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                restaurant.rating?.toString() ?? "-",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${restaurant.city ?? ''}, ${restaurant.address ?? ''}",
            style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder:
                    (context) => ReviewFormDialog(
                      restaurantId: restaurant.id.toString(),
                      onSubmit: (name, review) {
                        context.read<ReviewSubmitProvider>().submitReview(
                          restaurant.id.toString(),
                          name,
                          review,
                        );
                      },
                    ),
              );
              if (result == true) {
                debugPrint("Review success add");
              }
            },
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text("Add Review"),
          ),
          const SizedBox(height: 16),
          Text(
            restaurant.description ?? "",
            style: const TextStyle(fontSize: 16),
            maxLines: expandProvider.isExpanded ? null : 3,
            overflow:
                expandProvider.isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () {
              context.read<ExpandDescriptionProvider>().toggle();
            },
            child: Text(expandProvider.isExpanded ? "See Less" : "See More"),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Food Menu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        restaurant.menus?.foods
                            ?.map((food) => Chip(label: Text(food.name ?? "")))
                            .toList() ??
                        [],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Drinks Menu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        restaurant.menus?.drinks
                            ?.map(
                              (drink) => Chip(label: Text(drink.name ?? "")),
                            )
                            .toList() ??
                        [],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
