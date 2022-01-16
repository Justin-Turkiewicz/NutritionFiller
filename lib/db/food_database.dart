import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nutrtionfiller/model/food.dart';
import 'package:path/path.dart';
import 'package:sqfentity/sqfentity.dart';
class FoodDatabase {
  static final FoodDatabase instance = FoodDatabase._init();
  static Database? _database;

  FoodDatabase._init();

  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await openDB();
    return _database!;
  }


  Future<Database> openDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'foods.db');
    bool exists = await databaseExists(path);
    if(!exists) {
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load(join('assets','foods.db'));
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    await initDB();
    Database db = await openDatabase(path, readOnly: true);

    return db;
  }

  Future<void> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String newPath = join(documentsDirectory.path, 'foods.db');
    final exist = await databaseExists(newPath);
    if (!exist) {
      try {
        final dbPath = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOCUMENTS);
        final path = join(dbPath, 'foods.db');
        File(path).copySync(newPath);
      } catch (_) {}
    }
  }

  Future<List<Food>?> searchFood(String userInput) async {
    final db = await _database;
    List<Map<String, Object?>>? rows = await db?.query(
        'food', where: 'name LIKE ?', whereArgs: ['%$userInput%']);
    List<Food>? foods = rows?.map((food) => Food.fromMap(food)).toList();
    return foods;

  }


  // Future<Database> _initDB(String filePath) async{
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, filePath);
  //   return await openDatabase(path, version: 1, onCreate: _createDB);
  // }

  // Future _createDB(Database db, int version) async{
  //   final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  //   final textType = 'TEXT NOT NULL';
  //   await db.execute('''
  //     CREATE TABLE $tableFoods (
  //       ${FoodFields.id} $idType,
  //       ${FoodFields.name} $textType,
  //       ${FoodFields.imageUrl} $textType,
  //       ${FoodFields.nutritionValues} $textType
  //
  //     )
  //   ''');
  // }

  Future<Food> create(Food food) async{
    final db = await instance.database;

    final id = await db.insert(tableFoods, food.toJson());
    return food.copy(id: id);
  }

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

  Future<List<Food>> readAllFoods() async{
    final db = await instance.database;

    final orderBy = '${FoodFields.name} ASC';
    final result = await db.query(tableFoods, orderBy: orderBy);

    return result.map((json) => Food.fromJson(json)).toList();
  }

  Future<int> update(Food food) async {
    final db = await instance.database;

    return db.update(
        tableFoods,
        food.toJson(),
        where: '${FoodFields.id} = ?',
        whereArgs: [food.id],);
  }

  Future<int> delete(int id) async{
    final db = await instance.database;

    return await db.delete(
      tableFoods,
      where: '${FoodFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }


}