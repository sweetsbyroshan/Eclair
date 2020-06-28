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
  factory FoodModel.fromFirestore(DocumentSnapshot doc) {
    List<String> list = [];
    for (var item in doc.data['ingredientLines']) {
      list.add(item);
    }
    return FoodModel(
        image: doc.data['image'],
        label: doc.data['label'],
        url: doc.data['url'],
        source: doc.data['source'],
        ingredientLines: list);
  }
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
