import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/detail_restaurant_model.dart';
import '../models/list_restaurant_model.dart';
import '../models/search_restaurant_model.dart';
import '../models/submit_rating_restaurant_model.dart';

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

  Future<SearchRestaurantModel> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));
    return SearchRestaurantModel.fromJson(jsonDecode(response.body));
  }

  Future<RatingSubmissionModel> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/review"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "name": name, "review": review}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return RatingSubmissionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post review: ${response.body}');
    }
  }
}
