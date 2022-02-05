import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nutritionfiller/model/food.dart';
import 'package:path/path.dart';
import 'package:sqfentity/sqfentity.dart';
/*
  FoodDatabase is used to store the food database based on the food objects
 */
class FoodDatabase {
  /*
    instance Is instantiated right away
    _database Is used to retrieve the food database when needed
   */
  static final FoodDatabase instance = FoodDatabase._init();
  static Database? _database;
  /*
    Instantiates the Food Database object
   */
  FoodDatabase._init();

  /*
    On creation of FoodDatabase object, _database is set via the openDB method.
    Otherwise _database is returned
   */
  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await openDB();
    return _database!;
  }

  /*
    Finds the database and returns it
   */
  Future<Database> openDB() async {
    // Gets the database's path and make sure it exists on computer
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'foods.db');
    bool exists = await databaseExists(path);
    //If it does not exist creates database for computer at that path and loads data
    //if(!exists) {
    //  await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load(join('assets','foods.db'));
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
   // }
    //Calls initDB to make path for database on device
    //await initDB();
    // Opens the database provided at the path on computer
    Database db = await openDatabase(path, readOnly: true);
    return db;
  }

  Future<void> initDB() async {
    //Gets path for documents directory on device and joins that path with foods.db
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String newPath = join(documentsDirectory.path, 'foods.db');
    //Checks if that path already exists
    final exist = await databaseExists(newPath);
    /*
      If the file does not exist locally on the device, it gets the file's path
      from the installed app's files and then copies and pastes the file
      to the device's path
     */
    if (!exist) {
        final dbPath = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOCUMENTS);
        final path = join(dbPath, 'foods.db');
        File(path).copySync(newPath);
    }
  }

  /*
    Searches for food in the database. Not used currently
   */
  Future<List<Food>?> searchFood(String userInput) async {
    final db = await _database;
    List<Map<String, Object?>>? rows = await db?.query(
        'food', where: 'name LIKE ?', whereArgs: ['%$userInput%']);
    List<Food>? foods = rows?.map((food) => Food.fromMap(food)).toList();
    return foods;

  }

  /*
    Creates a food object from database. Not used currently
   */
  Future<Food> create(Food food) async{
    final db = await instance.database;

    final id = await db.insert(tableFoods, food.toJson());
    return food.copy(id: id);
  }

  /*
    Returns food from database. Not used currently
   */
  Future<Food> readFood(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableFoods,
      columns: FoodFields.values,
      where: '${FoodFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Food.fromJson(maps.first);
    }
    else{
      throw Exception('ID $id not found');
    }
  }


  /*
    Returns list of all the food objects in the database
   */
  Future<List<Food>> readAllFoods() async{
    final db = await instance.database;

    final orderBy = '${FoodFields.name} ASC';
    final result = await db.query(tableFoods, orderBy: orderBy);
    final test = result.map((json) => Food.fromJson(json)).toList();
    return test;
  }

  /*
    Updates database with a new Food object. Not used currently.
   */
  Future<int> update(Food food) async {
    final db = await instance.database;

    return db.update(
        tableFoods,
        food.toJson(),
        where: '${FoodFields.id} = ?',
        whereArgs: [food.id],);
  }

  /*
    Deletes a Food object from database. Not used currently.
   */
  Future<int> delete(int id) async{
    final db = await instance.database;

    return await db.delete(
      tableFoods,
      where: '${FoodFields.id} = ?',
      whereArgs: [id],
    );
  }

  /*
    Closes the database. Not used currently.
   */
  Future close() async {
    final db = await instance.database;
    db.close();
  }


}