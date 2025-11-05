import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/submit_review_provider.dart';
import 'package:restaurant_app/static/restaurant_review_result_state.dart';

class ReviewFormDialog extends StatelessWidget {
  final String restaurantId;

  const ReviewFormDialog({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ReviewSubmitProvider>();

    return Consumer<ReviewSubmitProvider>(
      builder: (context, consumer, _) {
        final state = consumer.submitState;

        if (state is ReviewLoadedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final messenger = ScaffoldMessenger.of(context);
            Navigator.pop(context, true);
            messenger.showSnackBar(
              const SnackBar(
                content: Text(
                  'Congrats, Submit review success..',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
            consumer.resetState();
          });
        }

        return AlertDialog(
          title: const Text('Give Review'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Form(
                key: provider.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: provider.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Name is required'
                                  : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: provider.reviewController,
                      decoration: const InputDecoration(
                        labelText: 'Review',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Review must be filled'
                                  : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed:
                  state is ReviewLoadingState
                      ? null
                      : () => provider.submitReview(restaurantId),
              child:
                  state is ReviewLoadingState
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
