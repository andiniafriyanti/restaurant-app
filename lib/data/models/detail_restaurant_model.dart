// To parse this JSON data, do
//
//     final detailRestaurantModel = detailRestaurantModelFromJson(jsonString);

import 'dart:convert';

DetailRestaurantModel detailRestaurantModelFromJson(String str) =>
    DetailRestaurantModel.fromJson(json.decode(str));

String detailRestaurantModelToJson(DetailRestaurantModel data) =>
    json.encode(data.toJson());

class DetailRestaurantModel {
  final bool? error;
  final String? message;
  final DetailRestaurant? restaurant;

  DetailRestaurantModel({this.error, this.message, this.restaurant});

  factory DetailRestaurantModel.fromJson(Map<String, dynamic> json) =>
      DetailRestaurantModel(
        error: json["error"],
        message: json["message"],
        restaurant:
            json["restaurant"] == null
                ? null
                : DetailRestaurant.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "restaurant": restaurant?.toJson(),
  };
}

class DetailRestaurant {
  final String? id;
  final String? name;
  final String? description;
  final String? city;
  final String? address;
  final String? pictureId;
  final List<Category>? categories;
  final Menus? menus;
  final double? rating;
  final List<CustomerReview>? customerReviews;

  DetailRestaurant({
    this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.categories,
    this.menus,
    this.rating,
    this.customerReviews,
  });

  factory DetailRestaurant.fromJson(Map<String, dynamic> json) =>
      DetailRestaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        city: json["city"],
        address: json["address"],
        pictureId: json["pictureId"],
        categories:
            json["categories"] == null
                ? []
                : List<Category>.from(
                  json["categories"]!.map((x) => Category.fromJson(x)),
                ),
        menus: json["menus"] == null ? null : Menus.fromJson(json["menus"]),
        rating: json["rating"]?.toDouble(),
        customerReviews:
            json["customerReviews"] == null
                ? []
                : List<CustomerReview>.from(
                  json["customerReviews"]!.map(
                    (x) => CustomerReview.fromJson(x),
                  ),
                ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "city": city,
    "address": address,
    "pictureId": pictureId,
    "categories":
        categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "menus": menus?.toJson(),
    "rating": rating,
    "customerReviews":
        customerReviews == null
            ? []
            : List<dynamic>.from(customerReviews!.map((x) => x.toJson())),
  };
}

class Category {
  final String? name;

  Category({this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}

class CustomerReview {
  final String? name;
  final String? review;
  final String? date;

  CustomerReview({this.name, this.review, this.date});

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
    name: json["name"],
    review: json["review"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "review": review,
    "date": date,
  };
}

class Menus {
  final List<Category>? foods;
  final List<Category>? drinks;

  Menus({this.foods, this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
    foods:
        json["foods"] == null
            ? []
            : List<Category>.from(
              json["foods"]!.map((x) => Category.fromJson(x)),
            ),
    drinks:
        json["drinks"] == null
            ? []
            : List<Category>.from(
              json["drinks"]!.map((x) => Category.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "foods":
        foods == null ? [] : List<dynamic>.from(foods!.map((x) => x.toJson())),
    "drinks":
        drinks == null
            ? []
            : List<dynamic>.from(drinks!.map((x) => x.toJson())),
  };
}
