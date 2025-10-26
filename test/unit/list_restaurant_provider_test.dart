import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/provider/list_restaurant_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:restaurant_app/data/models/list_restaurant_model.dart';
import 'package:restaurant_app/data/services/restaurant_services.dart';

class MockRestaurantServiceSuccess extends RestaurantServices {
  @override
  Future<ListRestaurantModel> getRestaurantList() async {
    return ListRestaurantModel(
      error: false,
      message: "Success",
      count: 1,
      restaurants: [
        Restaurant(
          id: "1",
          name: "Test Restaurant",
          description: "Great food",
          pictureId: "pic_1",
          city: "Jakarta",
          rating: 4.5,
        ),
      ],
    );
  }
}

class MockRestaurantServiceError extends RestaurantServices {
  @override
  Future<ListRestaurantModel> getRestaurantList() async {
    return ListRestaurantModel(
      error: true,
      message: "Failed to fetch data",
      restaurants: [],
    );
  }
}

void main() {
  group('RestaurantListProvider Test', () {
    test('State awal provider harus didefinisikan', () {
      final provider = RestaurantListProvider(MockRestaurantServiceSuccess());
      expect(provider.resultState, isA<RestaurantListNoneState>());
    });

    test('Mengembalikan daftar restoran ketika API sukses', () async {
      final provider = RestaurantListProvider(MockRestaurantServiceSuccess());

      await provider.fetchRestaurantList();

      expect(provider.resultState, isA<RestaurantListLoadedState>());

      final state = provider.resultState as RestaurantListLoadedState;
      expect(state.data.first.name, "Test Restaurant");
    });

    test('Mengembalikan error ketika API gagal', () async {
      final provider = RestaurantListProvider(MockRestaurantServiceError());

      await provider.fetchRestaurantList();

      expect(provider.resultState, isA<RestaurantListErrorState>());

      final state = provider.resultState as RestaurantListErrorState;
      expect(state.error, contains("Failed to fetch data"));
    });
  });
}
