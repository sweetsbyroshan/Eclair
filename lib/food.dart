import 'package:eclair/food_model.dart';
import 'package:eclair/pages/recipe2.dart';
import 'package:flutter/material.dart';

class Food extends StatelessWidget {
  FoodModel foodModel;

  Food({this.foodModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RecipePage2.routeName,
              arguments: foodModel);
        },
        child: Container(
          margin: EdgeInsets.all(4),
          child: Column(
            children: [
              Flexible(
                flex: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    foodModel.image,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Flexible(
                  flex: 3,
                  child: Text(foodModel.label,
                      style: Theme.of(context).textTheme.bodyText2))
            ],
          ),
        ));
  }
}
