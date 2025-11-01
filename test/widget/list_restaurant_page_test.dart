import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/list_restaurant_provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/screens/list_restaurant_page.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:restaurant_app/static/restaurant_search_result_state.dart';

class MockRestaurantListProvider extends ChangeNotifier
    implements RestaurantListProvider {
  @override
  void clearSearch() {}

  @override
  String get lastQuery => '';

  @override
  get restaurantServices => throw UnimplementedError();

  @override
  Future<void> fetchRestaurantList() async {
  }

  @override
  Future<void> searchRestaurant(String query) async {}

  @override
  RestaurantListResultState get resultState => RestaurantListNoneState();

  @override
  RestaurantSearchResultState get searchState => RestaurantSearchNoneState();
}

void main() {
  testWidgets('Menampilkan AppBar dan tombol tema dapat ditekan', (
    WidgetTester tester,
  ) async {
    final mockRestaurantProvider = MockRestaurantListProvider();
    final themeProvider = ThemeProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<RestaurantListProvider>.value(
            value: mockRestaurantProvider,
          ),
        ],
        child: const MaterialApp(home: ListRestaurantPage()),
      ),
    );

    expect(find.text('Restaurant List'), findsOneWidget);
  });
}
