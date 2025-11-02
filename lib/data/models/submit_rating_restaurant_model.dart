// To parse this JSON data, do
//
//     final ratingSubmissionModel = ratingSubmissionModelFromJson(jsonString);

import 'dart:convert';

RatingSubmissionModel ratingSubmissionModelFromJson(String str) =>
    RatingSubmissionModel.fromJson(json.decode(str));

String ratingSubmissionModelToJson(RatingSubmissionModel data) =>
    json.encode(data.toJson());

class RatingSubmissionModel {
  final bool? error;
  final String? message;
  final List<CustomerReview>? customerReviews;

  RatingSubmissionModel({this.error, this.message, this.customerReviews});

  factory RatingSubmissionModel.fromJson(Map<String, dynamic> json) =>
      RatingSubmissionModel(
        error: json["error"],
        message: json["message"],
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
    "error": error,
    "message": message,
    "customerReviews":
        customerReviews == null
            ? []
            : List<dynamic>.from(customerReviews!.map((x) => x.toJson())),
  };
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
