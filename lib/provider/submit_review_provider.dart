import 'package:flutter/foundation.dart';
import 'package:restaurant_app/static/restaurant_review_result_state.dart';
import '../data/services/restaurant_services.dart';

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
        _submitState = ReviewErrorState(result.message ?? 'Failed');
      } else {
        _submitState = ReviewLoadedState(result.message ?? 'Review Success');
      }
    } catch (e) {
      _submitState = ReviewErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void resetState() {
    _submitState = ReviewNoneState();
    notifyListeners();
  }
}
