import 'package:foodlist/event/Food.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {


  static const String TABLE_FOOD = "food";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_CALORIES = "calories";
  static const String COLUMN_VEGAN = "isVegan";

  static DatabaseProvider provider;

  Database db;

  DatabaseProvider._();



  static DatabaseProvider getInstance() {
    if (provider != null) return provider;

    provider = DatabaseProvider._();
    return provider;
  }

  Future<Database> get database async {

    if(db != null){
      return db;
    }

    db =  await createDatabase();
    return db;
  }

  Future<Database> createDatabase() async {
    String path = await getDatabasesPath();


    return openDatabase(
      join(path, "foodDb.db"),
      version: 1,
      onCreate: (Database database, int version) async {
        await database.execute(
          "CREATE TABLE $TABLE_FOOD ("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$COLUMN_NAME TEXT,"
              "$COLUMN_CALORIES TEXT,"
              "$COLUMN_VEGAN INTEGER"
              ")",
        );
      }
    );

  }


  Future<List<Food>> getFoods() async {
    
    final db = await database;

    var foods = await db.query(
      TABLE_FOOD, columns: [COLUMN_ID, COLUMN_NAME, COLUMN_CALORIES, COLUMN_VEGAN]
    );

    List<Food> foodList = new List<Food>();

    foods.forEach((food){
      foodList.add(Food.fromMap(food));
    });

    return foodList;
  }

  Future<int> insertFood(Food food) async{
    final db = await database;

    int id = await db.insert(TABLE_FOOD, food.toMap());

    return id;
  }


    Future<int> updateFood(Food food) async{
    final db = await database;

    int id = await db.update(TABLE_FOOD, food.toMap(), where: "id = ?", whereArgs: [food.id]);

    return id;
  }



    Future<int> deleteFood(int id) async{
    final db = await database;

    return await db.delete(TABLE_FOOD, where: "id = ?", whereArgs: [id]);

  }



}
