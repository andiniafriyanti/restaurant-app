import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/list_restaurant_model.dart';
import 'package:restaurant_app/data/services/restaurant_services.dart';
import 'package:restaurant_app/provider/list_restaurant_provider.dart';
import 'package:restaurant_app/screens/list_restaurant_page.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:restaurant_app/static/restaurant_search_result_state.dart';

class MockRestaurantListProvider extends ChangeNotifier
    implements RestaurantListProvider {
  @override
  RestaurantListResultState resultState = RestaurantListNoneState();

  @override
  RestaurantSearchResultState searchState = RestaurantSearchNoneState();

  @override
  Future<void> fetchRestaurantList() async {
    await Future.delayed(const Duration(milliseconds: 50));
    resultState = RestaurantListLoadedState([
      Restaurant(
        id: '1',
        name: 'Sushi Tei',
        description: 'Restoran Jepang',
        pictureId: 'pic1',
        city: 'Jakarta',
        rating: 4.8,
      ),
      Restaurant(
        id: '2',
        name: 'Kopi Kenangan',
        description: 'Kopi hits kekinian',
        pictureId: 'pic2',
        city: 'Bandung',
        rating: 4.5,
      ),
    ]);
    notifyListeners();
  }

  @override
  Future<void> searchRestaurant(String query) async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (query == 'empty') {
      searchState = RestaurantSearchErrorState("No restaurants found");
    } else {
      searchState = RestaurantSearchLoadedState([
        Restaurant(
          id: '1',
          name: 'Sushi Tei',
          description: 'Restoran Jepang',
          pictureId: 'pic1',
          city: 'Jakarta',
          rating: 4.8,
        ),
      ]);
    }
    notifyListeners();
  }

  @override
  RestaurantServices get restaurantServices => throw UnimplementedError();
}

void main() {
  testWidgets('Menampilkan daftar restoran ketika data berhasil dimuat', (
    WidgetTester tester,
  ) async {
    final mockProvider = MockRestaurantListProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<RestaurantListProvider>(
            create: (_) => mockProvider,
          ),
        ],
        child: const MaterialApp(home: ListRestaurantPage()),
      ),
    );

    await mockProvider.fetchRestaurantList();
    await tester.pumpAndSettle();

    expect(find.text('Sushi Tei'), findsOneWidget);
    expect(find.text('Kopi Kenangan'), findsOneWidget);
  });
}
