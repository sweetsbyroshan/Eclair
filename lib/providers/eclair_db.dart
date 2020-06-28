import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eclair/food_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class EclairDatabaseService {
  Future<Response> searchRecipe({String query}) {
    String baseUrl =
        'https://api.edamam.com/search?q=$query&app_id=d4d99420&app_key=c4d0b285d7a30086b79cf7395f6b965a';
    return http.get(baseUrl);
  }

  Future<Response> openRecipe({String recipe}) {
    String baseUrl =
        'https://api.edamam.com/search?app_id=d4d99420&app_key=c4d0b285d7a30086b79cf7395f6b965a&r=$recipe';
    return http.get(baseUrl);
  }

  Future<void> registerFCM(FirebaseUser value) async {
    var token = (await FirebaseMessaging().getToken());

    bool exists =
        (await Firestore.instance.document('users/${value.uid}').get()).exists;
    if (exists)
      return Firestore.instance
          .document('users/${value.uid}')
          .updateData({'token': token});
    else
      return Firestore.instance
          .document('users/${value.uid}')
          .setData({'token': token});
  }

  Future<void> signInAnonymously() {
    return FirebaseAuth.instance.signInAnonymously().then((value) {
      return registerFCM(value.user);
    });
  }

  Future<void> addFoodToUser(recipe) async {
    var value = (await FirebaseAuth.instance.currentUser());
    var db = Firestore.instance.document('users/${value.uid}');
    db.get().then((value) {
      List<dynamic> foodlist = value['foodlist'] ?? [];
      bool exists = false;
      for (var item in foodlist) {
        exists = item['label'] == recipe['recipe']['label'];
      }
      if (!exists) {
        foodlist.add({
          'label': recipe['recipe']['label'],
          'image': recipe['recipe']['image'],
          'uri': recipe['recipe']['uri'],
          'url': recipe['recipe']['url'],
          'ingredientLines': recipe['recipe']['ingredientLines'],
          'source': recipe['recipe']['source'],
          'whenCreated': Timestamp.now()
        });
        return db.updateData({'foodlist': foodlist});
      } else {
        Future.delayed(Duration(microseconds: 200));
      }
    });
  }

  Stream<User> checkIfFoodList(FirebaseUser value) {
    var db = Firestore.instance.document('users/${value.uid}');
    var ref = db.snapshots();
    return ref.map((doc) => User.fromFirestore(doc));
  }

  Future<DocumentReference> add2Favourite2(FoodModel foodModel) async {
    var value = (await FirebaseAuth.instance.currentUser());
    var db = Firestore.instance.collection('fav');
    return db.add({
      'userId': value.uid,
      'image': foodModel.image,
      'label': foodModel.label,
      'url': foodModel.url,
      'source': foodModel.source,
      'ingredientLines': foodModel.ingredientLines,
      'whenCreated': Timestamp.now(),
    });
  }

  Future<DocumentReference> add2Favourite(dynamic foodModel) async {
    var value = (await FirebaseAuth.instance.currentUser());
    var db = Firestore.instance.collection('fav');
    return db.add({
      'userId': value.uid,
      'image': foodModel['recipe']['image'],
      'label': foodModel['recipe']['label'],
      'url': foodModel['recipe']['url'],
      'source': foodModel['recipe']['source'],
      'ingredientLines': foodModel['recipe']['ingredientLines'],
      'whenCreated': Timestamp.now(),
    });
  }

  Stream<List<FoodModel>> getFavourite(uid) {
    var db = Firestore.instance
        .collection('fav')
        .where('userId', isEqualTo: uid)
        .orderBy('whenCreated', descending: true);
    return db.snapshots().map((event) =>
        event.documents.map((e) => FoodModel.fromFirestore(e)).toList());
  }

  Future<void> clearFavourite(uid) {
    return Firestore.instance
        .collection('fav')
        .where('userId', isEqualTo: uid)
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }

  Future<void> clearHistory(user) async {
    String token = (await FirebaseMessaging().getToken());
    return Firestore.instance
        .document('users/${user.uid}')
        .delete()
        .then((value) {
      var ref = Firestore.instance.document('user/${user.uid}');
      return ref.delete().then((value) => ref.setData({'token': token}));
    });
  }
}
