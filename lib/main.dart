
import 'package:flutter/material.dart';
import 'package:foodlist/food_from.dart';
import 'package:foodlist/food_list.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Food List",
      theme: ThemeData.dark(),
      home: FoodList(),
      routes: {
        FoodForm.routeName : (context)=> FoodForm()
      },
    );
  }
}

