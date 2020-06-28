import 'dart:convert';

import 'package:eclair/pages/recipe.dart';
import 'package:eclair/providers/eclair_db.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchPage extends StatelessWidget {
  static const routeName = 'searchPage';
  @override
  Widget build(BuildContext context) {
    String query = ModalRoute.of(context).settings.arguments;
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
                  child: IconButton(
                    icon: Icon(Icons.keyboard_backspace),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text(
                  'Search results for',
                  style: Theme.of(context).textTheme.headline1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '$query',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                FutureBuilder<Response>(
                    future: EclairDatabaseService().searchRecipe(query: query),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return LinearProgressIndicator();
                        default:
                          var data = snapshot.data.body;
                          var jsox = json.decode(data);
                          List<dynamic> hits = jsox['hits'];
                          return ListView.builder(
                              itemBuilder: (c, i) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: FlatButton(
                                    onPressed: () {
                                      print(hits[i]);
                                      Navigator.of(context).pushNamed(
                                          RecipePage.routeName,
                                          arguments: hits[i]);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            flex: 3,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                hits[i]['recipe']['image'],
                                              ),
                                            )),
                                        Flexible(
                                            flex: 7,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    hits[i]['recipe']['label'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                            flex: 1,
                                                            child: Text(
                                                              '${hits[i]['recipe']['yield'].toString().replaceAll('.0', '')} servings',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText2
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10),
                                                            )),
                                                        Flexible(
                                                            flex: 1,
                                                            child: SizedBox(
                                                                width: 12)),
                                                        Flexible(
                                                            child: Text(
                                                                '${hits[i]['recipe']['ingredientLines'].length.toString()} ingredients',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText2
                                                                    .copyWith(
                                                                        fontSize:
                                                                            10))),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    hits[i]['recipe']['source'],
                                                  ),
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: hits.length,
                              shrinkWrap: true,
                              primary: false);
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
