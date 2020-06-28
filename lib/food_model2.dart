import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  String image, label, url, source;
  Timestamp whenCreated;
  List<String> ingredientLines;
  FoodModel({
    this.image,
    this.label,
    this.url,
    this.source,
    this.ingredientLines,
    this.whenCreated,
  });
}

class User {
  String token;
  List<dynamic> foodModel;
  User({
    this.token,
    this.foodModel,
  });
  factory User.fromFirestore(DocumentSnapshot doc) {
    return User(
      token: doc.data['token'],
      foodModel: doc.data['foodlist'],
    );
  }
}
