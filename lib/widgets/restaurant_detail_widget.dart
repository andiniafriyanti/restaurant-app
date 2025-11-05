import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/detail_restaurant_model.dart';
import 'package:restaurant_app/data/models/list_restaurant_model.dart';
import 'package:restaurant_app/provider/expand_description_provider.dart';
import 'package:restaurant_app/provider/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/submit_review_provider.dart';
import 'package:restaurant_app/widgets/review_dialog_widget.dart';

class RestaurantDetail extends StatelessWidget {
  final DetailRestaurant restaurant;
  final Restaurant? listRestaurant;
  const RestaurantDetail({
    super.key,
    required this.restaurant,
    this.listRestaurant,
  });

  @override
  Widget build(BuildContext context) {
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    final favoriteIconProvider = context.read<FavoriteIconProvider>();
    final restaurantId = restaurant.id;

    final isFavorite = localDatabaseProvider.checkItemFavorite(restaurantId!);
    favoriteIconProvider.setFavorite(restaurantId, isFavorite);

    final expandProvider = context.watch<ExpandDescriptionProvider>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  restaurant.name ?? "-",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () async {
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

                  favoriteIconProvider.toggleFavorite(restaurantId);
                  await localDatabaseProvider.loadAllRestaurantValue();
                },
                icon: Icon(
                  context.watch<FavoriteIconProvider>().isFavorite(restaurantId)
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
              context.read<ReviewSubmitProvider>().prepareNewReview();
              final result = await showDialog<bool>(
                context: context,
                builder:
                    (context) => ReviewFormDialog(
                      restaurantId: restaurant.id.toString(),
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
