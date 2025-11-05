import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/list_restaurant_model.dart';
import 'package:restaurant_app/data/services/restaurant_services.dart';
import 'package:restaurant_app/provider/list_restaurant_provider.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/screens/list_restaurant_page.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:restaurant_app/static/restaurant_search_result_state.dart';

class MockRestaurantListProvider extends ChangeNotifier
    implements RestaurantListProvider {
  @override
  final searchController = TextEditingController();

  @override
  void clearSearch() {}

  @override
  String get lastQuery => '';

  @override
  RestaurantServices get restaurantServices => throw UnimplementedError();

  @override
  Future<void> fetchRestaurantList() async {}

  @override
  Future<void> searchRestaurant([String? query]) async {}

  @override
  RestaurantListResultState get resultState => RestaurantListLoadedState([]);

  @override
  RestaurantSearchResultState get searchState => RestaurantSearchNoneState();
}

class MockLocalDatabaseProvider extends ChangeNotifier
    implements LocalDatabaseProvider {
  List<Restaurant> get favorites => [];

  @override
  bool checkItemFavorite(String id) => false;

  @override
  Future<void> loadAllRestaurantValue() async {}

  @override
  Future<void> loadRestaurantValueById(String id) async {}

  @override
  String get message => '';

  @override
  Future<void> removeRestaurantValueById(String id) async {}

  @override
  Future<void> saveRestaurantValue(Restaurant value) async {}

  @override
  Restaurant? get restaurant => null;

  @override
  List<Restaurant>? get restaurantList => [];
}

class MockRestaurantDetailProvider extends ChangeNotifier
    implements RestaurantDetailProvider {
  @override
  Future<void> fetchRestaurantDetail(String id) async {}

  @override
  RestaurantServices get restaurantServices => throw UnimplementedError();

  @override
  RestaurantDetailResultState get resultState => RestaurantDetailNoneState();
}

void main() {
  testWidgets('Menampilkan AppBar dan judul yang benar', (
    WidgetTester tester,
  ) async {
    final mockListProvider = MockRestaurantListProvider();
    final mockDetailProvider = MockRestaurantDetailProvider();
    final mockDbProvider = MockLocalDatabaseProvider();
    final themeProvider = ThemeProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<RestaurantListProvider>.value(
            value: mockListProvider,
          ),
          ChangeNotifierProvider<RestaurantDetailProvider>.value(
            value: mockDetailProvider,
          ),
          ChangeNotifierProvider<LocalDatabaseProvider>.value(
            value: mockDbProvider,
          ),
        ],
        child: const MaterialApp(home: ListRestaurantPage()),
      ),
    );
    expect(find.text('Restaurant List'), findsOneWidget);
  });
}
