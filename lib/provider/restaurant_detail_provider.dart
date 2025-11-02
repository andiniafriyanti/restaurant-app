import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/services/restaurant_services.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

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
          'Gagal memuat detail. Coba lagi nanti.',
        );
      } else {
        _resultState = RestaurantDetailLoadedState(result.restaurant!);
      }
    } catch (e) {
      _resultState = RestaurantDetailErrorState(
        'Gagal memuat detail restoran. Periksa koneksi internet Anda.',
      );
    } finally {
      notifyListeners();
    }
  }
}
