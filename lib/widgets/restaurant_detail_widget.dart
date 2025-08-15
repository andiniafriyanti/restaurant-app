import 'package:flutter/material.dart';
import 'package:restaurant_app/widgets/review_dialog_widget.dart';

import '../data/models/detail_restaurant_model.dart';

class RestaurantDetail extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantDetail({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.name!,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "${restaurant.city!}, ${restaurant.address!}",
          style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            _showReviewForm(context);
            // showDialog(
            //   context: context,
            //   builder:
            //       (context) => AlertDialog(
            //         title: const Text('COMING SOON'),
            //         content: const Text('This feature is coming soon.'),
            //         actions: [
            //           TextButton(
            //             onPressed: () => Navigator.of(context).pop(),
            //             child: const Text('OK'),
            //           ),
            //         ],
            //       ),
            // );
          },
          icon: const Icon(Icons.rate_review_outlined),
          label: const Text("Add Review"),
        ),
        const SizedBox(height: 16),
        Text(restaurant.description!, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

void _showReviewForm(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => ReviewFormDialog(
          onSubmit: (name, review) {
            debugPrint("Nama: $name");
            debugPrint("Ulasan: $review");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Terima kasih atas reviewnya, $name!")),
            );
          },
        ),
  );
}
