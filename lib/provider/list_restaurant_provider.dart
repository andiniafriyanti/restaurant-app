import 'package:flutter/widgets.dart';
import 'package:restaurant_app/static/restaurant_search_result_state.dart';

import '../data/models/list_restaurant_model.dart';
import '../data/services/restaurant_services.dart';
import '../static/restaurant_list_result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantServices restaurantServices;

  RestaurantListProvider(this.restaurantServices);

  RestaurantListResultState _resultState = RestaurantListNoneState();

  RestaurantListResultState get resultState => _resultState;

  RestaurantSearchResultState _searchState = RestaurantSearchNoneState();
  RestaurantSearchResultState get searchState => _searchState;

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

  Future<void> searchRestaurant(String query) async {
    try {
      _searchState = RestaurantSearchLoadingState();
      notifyListeners();

      final response = await restaurantServices.searchRestaurants(query);
      final restaurantLists = response.restaurants ?? [];

      if (restaurantLists.isEmpty) {
        _searchState = RestaurantSearchErrorState(
          "No restaurants found for '$query'",
        );
      } else {
        final restaurants =
            restaurantLists.map((data) {
              return Restaurant(
                id: data.id,
                name: data.name,
                description: data.description,
                pictureId: data.pictureId,
                city: data.city,
                rating: data.rating,
              );
            }).toList();
        _searchState = RestaurantSearchLoadedState(restaurants);
      }
      notifyListeners();
    } catch (e) {
      _searchState = RestaurantSearchErrorState(e.toString());
      notifyListeners();
    }
  }
}
