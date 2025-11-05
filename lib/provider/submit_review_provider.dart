import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/services/restaurant_services.dart';
import 'package:restaurant_app/static/restaurant_review_result_state.dart';

class ReviewSubmitProvider extends ChangeNotifier {
  final RestaurantServices restaurantServices;

  final nameController = TextEditingController();
  final reviewController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ReviewSubmitProvider(this.restaurantServices);

  ReviewResultState _submitState = ReviewNoneState();

  ReviewResultState get submitState => _submitState;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    reviewController.dispose();
  }

  Future<void> submitReview(String id) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final name = nameController.text.trim();
    final review = reviewController.text.trim();

    _submitState = ReviewLoadingState();
    notifyListeners();

    try {
      final result = await restaurantServices.postReview(
        id: id,
        name: name,
        review: review,
      );

      if (result.error ?? true) {
        _submitState = ReviewErrorState(
          'Gagal mengirim ulasan. Coba lagi nanti.',
        );
      } else {
        _submitState = ReviewLoadedState(
          result.message ?? 'Ulasan berhasil dikirim',
        );
      }
    } catch (e) {
      _submitState = ReviewErrorState(
        'Gagal mengirim ulasan. Periksa koneksi internet Anda.',
      );
    } finally {
      notifyListeners();
    }
  }

  void resetState() {
    _submitState = ReviewNoneState();
  }

  void prepareNewReview() {
    nameController.clear();
    reviewController.clear();
  }
}
