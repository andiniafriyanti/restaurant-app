// To parse this JSON data, do
//
//     final detailRestaurantModel = detailRestaurantModelFromJson(jsonString);

import 'dart:convert';

SearchRestaurantModel searchRestaurantModelFromJson(String str) =>
    SearchRestaurantModel.fromJson(json.decode(str));

String searchRestaurantModelToJson(SearchRestaurantModel data) =>
    json.encode(data.toJson());

class SearchRestaurantModel {
  final bool? error;
  final int? founded;
  final List<RestaurantList>? restaurants;

  SearchRestaurantModel({this.error, this.founded, this.restaurants});

  factory SearchRestaurantModel.fromJson(Map<String, dynamic> json) =>
      SearchRestaurantModel(
        error: json["error"],
        founded: json["founded"],
        restaurants:
            json["restaurants"] == null
                ? []
                : List<RestaurantList>.from(
                  json["restaurants"]!.map((x) => RestaurantList.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "founded": founded,
    "restaurants":
        restaurants == null
            ? []
            : List<dynamic>.from(restaurants!.map((x) => x.toJson())),
  };
}

class RestaurantList {
  final String? id;
  final String? name;
  final String? description;
  final String? pictureId;
  final String? city;
  final double? rating;

  RestaurantList({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) => RestaurantList(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    pictureId: json["pictureId"],
    city: json["city"],
    rating: json["rating"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
  };
}
