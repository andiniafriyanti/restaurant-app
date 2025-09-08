import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/widgets/review_dialog_widget.dart';
import '../data/models/detail_restaurant_model.dart';
import '../provider/submit_review_provider.dart';

class RestaurantDetail extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetail({super.key, required this.restaurant});

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name ?? "-",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    "Menu Makanan",
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
                    "Menu Minuman",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        restaurant.menus?.drinks?.map(
                              (drink) => Chip(label: Text(drink.name ?? "")),
                            ).toList() ?? [],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            restaurant.description ?? "",
            style: const TextStyle(fontSize: 16),
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(isExpanded ? "See Less" : "See More"),
          ),
        ],
      ),
    );
  }
}
