
import 'package:foodlist/event/Food.dart';

abstract class Event{}


class AddFoodEvent extends Event {

  final Food food;

  AddFoodEvent(this.food);

}

class UpdateFoodEvent extends Event {

  final Food food;
  final int id;

  UpdateFoodEvent(this.food, this.id);

}

class GetFoodEvent extends Event{

  GetFoodEvent();

}

class DeleteFoodEvent extends Event {

  final int id;

  DeleteFoodEvent(this.id);


}
