import 'package:flutter/material.dart';
import 'package:foodlist/bloc/food_bloc.dart';
import 'package:foodlist/event/Food.dart';
import 'package:foodlist/event/event.dart';

class FoodForm extends StatefulWidget {
  static const String routeName = "/foodForm";

  final Food food;
  final int id;

  FoodForm({this.food, this.id});

  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;

  String _calories;

  bool _isVegan = false;

  Widget foodName(BuildContext context) {
    return TextFormField(
      initialValue: _name,
      maxLength: 15,
      decoration: InputDecoration(labelText: "Name"),
      style: TextStyle(fontSize: 20),
      validator: (value) {
        if (value.isEmpty) {
          return "Name cannot be empty";
        }

        return null;
      },
      onSaved: (value) {
        _name = value;
      },
    );
  }

  Widget foodCalories(BuildContext context) {
    return TextFormField(
      initialValue: _calories,
      maxLength: 15,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: "Calories"),
      style: TextStyle(fontSize: 20),
      validator: (value) {
        int calories = int.tryParse(value);

        if (calories == null || calories <= 0 || value.startsWith("0")) {
          return "Calories must be greater than zero";
        }

        return null;
      },
      onSaved: (value) {
        _calories = value;
      },
    );
  }

  Widget vegan(BuildContext context) {
    return SwitchListTile(
      title: Text(
        "Vegan",
        style: TextStyle(fontSize: 15),
      ),
      value: _isVegan,
      onChanged: (value) {
        setState(() {
          _isVegan = value;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.food != null) {
      _name = widget.food.name;
      _calories = widget.food.calories;
      _isVegan = widget.food.isVegan;
    }
  }

  Widget buttons(BuildContext context) {
    if (widget.food == null) {
      return RaisedButton(
        onPressed: () {
          if (!(_formKey.currentState.validate())) {
            return;
          }
          _formKey.currentState.save();

          Food food = Food(name: _name, calories: _calories, isVegan: _isVegan);

          FoodBloc.getInstance().add(AddFoodEvent(food));

          Navigator.pop(context);
        },
        child: Text("Submit"),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            if (!(_formKey.currentState.validate())) {
              return;
            }
            _formKey.currentState.save();

            Food food =
                Food(id:widget.food.id, name: _name, calories: _calories, isVegan: _isVegan);

            FoodBloc.getInstance().add(UpdateFoodEvent(food, widget.food.id));

            Navigator.pop(context);
          },
          child: Text("Update"),
        ),


        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      foodName(context),
                      SizedBox(
                        height: 10,
                      ),
                      foodCalories(context),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                vegan(context),
                SizedBox(
                  height: 25,
                ),
                buttons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
