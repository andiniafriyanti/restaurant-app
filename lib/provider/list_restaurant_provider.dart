import 'package:flutter/widgets.dart';

import '../data/services/restaurant_services.dart';
import '../static/restaurant_list_result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantServices restaurantServices;

  RestaurantListProvider(this.restaurantServices);

  RestaurantListResultState _resultState = RestaurantListNoneState();

  RestaurantListResultState get resultState => _resultState;

  Future<void> fetchRestaurantList() async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();
      final result = await restaurantServices.getRestaurantList();

      if (result.error!) {
        _resultState = RestaurantListErrorState(result.message ?? '');
        notifyListeners();
      } else {
        _resultState = RestaurantListLoadedState(result.restaurants!);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantListErrorState(e.toString());
      notifyListeners();
    }
  }
}
