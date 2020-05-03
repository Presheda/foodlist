import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodlist/bloc/food_bloc.dart';
import 'package:foodlist/event/Food.dart';
import 'package:foodlist/event/event.dart';
import 'package:foodlist/food_from.dart';

class FoodList extends StatefulWidget {
  FoodList({Key key}) : super(key: key);

  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  FoodBloc foodBloc;

  @override
  void initState() {
    super.initState();
    foodBloc = FoodBloc.getInstance();
    foodBloc.add(GetFoodEvent());
  }


  _showDialog(BuildContext context, Food food){

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          ""
        ),
        title: Text(food.name),
        actions: <Widget>[
          FlatButton(
              onPressed: (){
                Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => FoodForm(food: food,)
              ));
              },
              child: Text("Update", style: TextStyle(color: Colors.blue),)
          ),

          FlatButton(
              onPressed: (){
                foodBloc.add(DeleteFoodEvent(food.id));
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red),)
          ),
          FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.white),)
          ),

        ],
      ),


    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FoodList"),

      ),

      body: BlocBuilder<FoodBloc, List<Food>>(
        bloc: FoodBloc.getInstance(),
        builder: (context, food){
          return ListView.separated(

            itemCount: food != null ? food.length : 0,
            itemBuilder: (c, i){
              return ListTile(
                onTap: (){
                  _showDialog(context, food[i]);
                },
                title: Text(food[i].name, style: TextStyle(fontSize: 25),),
                subtitle: Text(
                  "Calories : ${food[i].calories}\nVegan: ${food[i].isVegan}",
                  style: TextStyle(fontSize: 20),
                ),
              );
            },

            separatorBuilder: (BuildContext context, int index) => Divider(),


          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, FoodForm.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}