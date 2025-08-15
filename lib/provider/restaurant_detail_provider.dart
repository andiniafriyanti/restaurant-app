import 'package:flutter/widgets.dart';
import '../data/services/restaurant_services.dart';
import '../static/restaurant_detail_result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantServices restaurantServices;

  RestaurantDetailProvider(this.restaurantServices);

  RestaurantDetailResultState _resultState = RestaurantDetailNoneState();
  RestaurantDetailResultState get resultState => _resultState;

  Future<void> fetchRestaurantDetail(String id) async {
    _resultState = RestaurantDetailLoadingState();
    notifyListeners();

    try {
      final result = await restaurantServices.getRestaurantDetail(id);

      if (result.error ?? true) {
        _resultState = RestaurantDetailErrorState(
          result.message ?? 'Terjadi kesalahan',
        );
      } else {
        _resultState = RestaurantDetailLoadedState(result.restaurant!);
      }
    } catch (e) {
      _resultState = RestaurantDetailErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
