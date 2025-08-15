import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/detail_restaurant_model.dart';
import '../models/list_restaurant_model.dart';

class RestaurantServices {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<ListRestaurantModel> getRestaurantList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      return ListRestaurantModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<DetailRestaurantModel> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      return DetailRestaurantModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }
}
