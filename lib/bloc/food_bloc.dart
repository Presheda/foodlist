import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodlist/event/Food.dart';
import 'package:foodlist/event/event.dart';
import 'package:foodlist/provider/detabase_provider.dart';

class FoodBloc extends Bloc<Event, List<Food>> {
  static FoodBloc _foodBloc;

  FoodBloc._();

  static FoodBloc getInstance() {
    if (_foodBloc != null) {
      return _foodBloc;
    }

    _foodBloc = FoodBloc._();
    return _foodBloc;
  }

  @override
  List<Food> get initialState => List<Food>();

  @override
  Stream<List<Food>> mapEventToState(Event event) async* {
    if (event is AddFoodEvent) {
      await _addFood(event.food);
      yield await _foodList();
    } else if (event is UpdateFoodEvent) {
      await _updateFood(event.food, event.id);
      yield await _foodList();
    } else if (event is DeleteFoodEvent) {
      await _deleteFood(event.id);
      yield await _foodList();
    } else if (event is GetFoodEvent) {
      yield await _foodList();
    } else {

      yield state;
    }
  }

  Future<List<Food>> _foodList() async {
    List<Food> food = await DatabaseProvider.getInstance().getFoods();

    print(food);

    print(food.length);

    return food;
  }

  Future<Null> _addFood(Food food) async {
    await DatabaseProvider.getInstance().insertFood(food);
  }

  Future<Null> _updateFood(Food food, int id) async {
    await DatabaseProvider.getInstance().updateFood(food);
  }

  Future<Null> _deleteFood(int id) async {
    await DatabaseProvider.getInstance().deleteFood(id);
  }
}
