import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/submit_review_provider.dart';
import '../static/restaurant_review_result_state.dart';

class ReviewFormDialog extends StatefulWidget {
  final String restaurantId;
  final void Function(String name, String review) onSubmit;

  const ReviewFormDialog({
    super.key,
    required this.onSubmit,
    required this.restaurantId,
  });

  @override
  State<ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<ReviewFormDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewSubmitProvider>(
      builder: (context, provider, _) {
        final state = provider.submitState;
        if (state is ReviewLoadedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context, true);
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    'Congrats, Submit review success..',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
              provider.resetState();
            }
          });
        }

        return AlertDialog(
          title: const Text('Give Review'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
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
                      controller: reviewController,
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
                      : () {
                        if (formKey.currentState!.validate()) {
                          final name = nameController.text.trim();
                          final review = reviewController.text.trim();
                          debugPrint(
                            "Send clicked: name=$name, review=$review",
                          );
                          widget.onSubmit(name, review);
                        }
                      },
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
