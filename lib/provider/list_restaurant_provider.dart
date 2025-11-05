import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/models/list_restaurant_model.dart';
import 'package:restaurant_app/data/services/restaurant_services.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:restaurant_app/static/restaurant_search_result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantServices restaurantServices;
  final searchController = TextEditingController();

  RestaurantListProvider(this.restaurantServices);

  RestaurantListResultState _resultState = RestaurantListNoneState();
  RestaurantListResultState get resultState => _resultState;

  RestaurantSearchResultState _searchState = RestaurantSearchNoneState();
  RestaurantSearchResultState get searchState => _searchState;

  String _lastQuery = '';
  String get lastQuery => _lastQuery;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchRestaurantList() async {
    if (_resultState is RestaurantListLoadingState ||
        _resultState is RestaurantListLoadedState) {
      return;
    }

    _resultState = RestaurantListLoadingState();
    Future.microtask(() => notifyListeners());

    try {
      final result = await restaurantServices.getRestaurantList();

      if (result.error ?? true) {
        _resultState = RestaurantListErrorState(
          result.message ?? 'Unknown error',
        );
      } else {
        _resultState = RestaurantListLoadedState(result.restaurants ?? []);
      }
    } catch (e) {
      _resultState = RestaurantListErrorState(e.toString());
    }
    notifyListeners();
  }

  Future<void> searchRestaurant([String? query]) async {
    final searchQuery = query ?? searchController.text;
    _lastQuery = searchQuery;
    notifyListeners();

    if (searchQuery.isEmpty) {
      clearSearch();
      return;
    }

    try {
      _searchState = RestaurantSearchLoadingState();
      notifyListeners();

      final response = await restaurantServices.searchRestaurants(searchQuery);
      final restaurantLists = response.restaurants ?? [];

      if (restaurantLists.isEmpty) {
        _searchState = RestaurantSearchErrorState(
          "No restaurants found for '$searchQuery'",
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
    } catch (e) {
      _searchState = RestaurantSearchErrorState(e.toString());
    }
    notifyListeners();
  }

  void clearSearch() {
    _lastQuery = '';
    searchController.clear();
    _searchState = RestaurantSearchNoneState();
    notifyListeners();
    fetchRestaurantList();
  }
}
