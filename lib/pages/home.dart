import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclair/pages/favourite.dart';
import 'package:eclair/pages/search.dart';
import 'package:eclair/providers/eclair_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../food.dart';
import '../food_model.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'homePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> fKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int fd = int.parse(DateFormat('kk').format(DateTime.now()));
    String greetings = '';
    if (fd >= 0 && fd < 12) {
      greetings = 'Good Morning';
    } else if (fd > 12 && fd < 16) {
      greetings = 'Good Afternoon';
    } else {
      greetings = 'Good Evening';
    }
    EclairDatabaseService().signInAnonymously();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetings,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          'What would you like to cook?',
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(FavouritePage.routeName);
                      },
                    )
                  ],
                ),
                TextField(
                  maxLines: 1,
                  key: fKey,
                  onSubmitted: (c) {
                    // if (fKey.currentState.validate())
                    Navigator.of(context)
                        .pushNamed(SearchPage.routeName, arguments: c);
                  },
                  decoration: InputDecoration(
                      prefixIcon: Image.asset('assets/grocery.png'),
                      hoverColor: Color(0xFF160601),
                      labelStyle: TextStyle(
                        color: Color(0x55160601),
                      ),
                      labelText: 'What do you have in your fridge?'),
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
                          return StreamBuilder<User>(
                              stream: EclairDatabaseService()
                                  .checkIfFoodList(snap.data),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                }
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return LinearProgressIndicator();
                                    break;
                                  default:
                                    if (snapshot.data.foodModel == null ||
                                        snapshot.data.foodModel.length == 0)
                                      return heyFoodie(context);
                                    else {
                                      List<FoodModel> foodModel = [];
                                      for (var item
                                          in snapshot.data.foodModel) {
                                        List<String> iLines = [];
                                        for (var item2
                                            in item['ingredientLines']) {
                                          iLines.add(item2.toString());
                                        }
                                        foodModel.add(FoodModel(
                                          image: item['image'],
                                          ingredientLines: iLines,
                                          label: item['label'],
                                          source: item['source'],
                                          url: item['url'],
                                          whenCreated: item['whenCreated'],
                                        ));
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Previously Searched',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          previouslySearched(
                                              foodModel, snap.data),
                                        ],
                                      );
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

  Widget previouslySearched(List<FoodModel> foodModel, user) {
    return Column(
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
          child: Text('Clear History'),
          onPressed: () {
            setState(() {
              EclairDatabaseService().clearHistory(user);
            });
          },
        )
      ],
    );
  }

  Widget heyFoodie(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Hello foodie',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: CachedNetworkImage(
              imageUrl: 'https://media.giphy.com/media/b5Hcaz7EPz26I/giphy.gif',
              width: MediaQuery.of(context).size.width * .6,
            )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Let\'s browse your kitchen and search what you can cook today',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
