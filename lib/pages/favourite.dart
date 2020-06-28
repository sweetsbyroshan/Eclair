import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclair/pages/search.dart';
import 'package:eclair/providers/eclair_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../food.dart';
import '../food_model.dart';

class FavouritePage extends StatelessWidget {
  static const routeName = 'favouritePage';
  final GlobalKey<FormState> fKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 4,
                        child: Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: IconButton(
                                icon: Icon(Icons.keyboard_backspace),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Flexible(
                              flex: 8,
                              child: Text(
                                'Favourites',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                StreamBuilder<FirebaseUser>(
                    stream: FirebaseAuth.instance.onAuthStateChanged,
                    builder: (ctx, snap) {
                      if (snap.hasError) {
                        return Text(snap.error.toString());
                      }
                      switch (snap.connectionState) {
                        case ConnectionState.waiting:
                          return LinearProgressIndicator();
                          break;
                        default:
                          return StreamBuilder<List<FoodModel>>(
                              stream: EclairDatabaseService()
                                  .getFavourite(snap.data.uid),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return Text(snapshot.error.toString());
                                }
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return LinearProgressIndicator();
                                    break;
                                  default:
                                    if (snapshot.data == null ||
                                        snapshot.data.length == 0)
                                      return heyFoodie(context);
                                    else {
                                      List<FoodModel> foodModel = [];
                                      for (var item in snapshot.data) {
                                        foodModel.add(FoodModel(
                                          image: item.image,
                                          ingredientLines: item.ingredientLines,
                                          label: item.label,
                                          source: item.source,
                                          url: item.url,
                                          whenCreated: item.whenCreated,
                                        ));
                                      }

                                      return previouslySearched(
                                          foodModel, snap.data.uid);
                                    }
                                }
                              });
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget previouslySearched(List<FoodModel> foodModel, uid) {
    return Center(
      child: Column(
        children: [
          GridView.builder(
              itemCount: foodModel.length,
              shrinkWrap: true,
              primary: false,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (ctx, i) {
                return Food(foodModel: foodModel[i]);
              }),
          FlatButton(
            child: Text('Clear Favourites'),
            onPressed: () {
              EclairDatabaseService().clearFavourite(uid);
            },
          )
        ],
      ),
    );
  }

  Widget heyFoodie(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'No recipe favourites yet',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
                imageUrl:
                    'https://media.giphy.com/media/z1vH4ys40yq4M/giphy.gif',
                width: MediaQuery.of(context).size.width)),
      ],
    );
  }
}
