import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/services/restaurant_services.dart';
import 'package:restaurant_app/static/restaurant_review_result_state.dart';

class ReviewSubmitProvider extends ChangeNotifier {
  final RestaurantServices restaurantServices;

  ReviewSubmitProvider(this.restaurantServices);

  ReviewResultState _submitState = ReviewNoneState();

  ReviewResultState get submitState => _submitState;

  Future<void> submitReview(String id, String name, String review) async {
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
    notifyListeners();
  }
}
