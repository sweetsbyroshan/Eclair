import 'package:eclair/food_model.dart';
import 'package:eclair/providers/eclair_db.dart';
import 'package:flutter/material.dart';

class RecipePage2 extends StatelessWidget {
  static const routeName = 'recipePage2';

  @override
  Widget build(BuildContext context) {
    FoodModel recipe = ModalRoute.of(context).settings.arguments;
    print(recipe);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          EclairDatabaseService().add2Favourite2(recipe);
        },
        child: Icon(Icons.favorite),
      ),
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
                                recipe.label,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    recipe.image,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * .3,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  recipe.label,
                  style: Theme.of(context).textTheme.headline1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                ListView.builder(
                    itemBuilder: (c, i) {
                      return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(recipe.ingredientLines[i]));
                    },
                    itemCount: recipe.ingredientLines.length,
                    shrinkWrap: true,
                    primary: false),
                Row(
                  children: [
                    Text(
                      'Instructions : ',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              'on ',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              recipe.source,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                      decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
