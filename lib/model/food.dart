import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// Name of database table
final String tableFoods = 'foods';

/*
 FoodFields holds the names of the fields in the foods table in a List variable
 */
class FoodFields{
  static final List<String> values = [
    id, name, imageUrl, nutritionValues
  ];

  static final String id = 'id';
  static final String name = 'name';
  static final String imageUrl = 'imageUrl';
  static final String nutritionValues = 'nutritionValues';

}
/*
  Food class holds information for each food
 */
class Food{
  /*
    id Is the food _id in the database
    name Is the name of the food
    imageUrl Is the name of the image file stored in assets/images
    nutritionValues Stores all the nutritional information of the food
   */
  int? id;
  late String name;
  late String imageUrl;
  late List<double> nutritionValues;

  /*
    Constructor for Food object
   */
  Food({this.id, required this.name, required this.imageUrl, required this.nutritionValues});

  /*
    Clones a Food object. Deep clones the nutritionValues
   */
  factory Food.clone(Food aFood){
    return new Food(
        id: aFood.id,
        name: aFood.name,
        imageUrl: aFood.imageUrl,
        nutritionValues: aFood.nutritionValues.toList());
  }

  /*
    Sets attributes of Food object based on the mapped input
   */
  Food.fromMap(dynamic obj){
    this.id = obj['id'];
    this.name = obj['name'];
    this.imageUrl = obj['imageUrl'];
    this.nutritionValues = obj['nutritionValues'];
  }

  /*
    Creates food object based on input from json with String keys and object values
   */
  static Food fromJson(Map<String, Object?> json) => Food(
      id: json[FoodFields.id] as int?,
      name: json[FoodFields.name] as String,
      imageUrl: json[FoodFields.imageUrl] as String,
      nutritionValues: (jsonDecode(json[FoodFields.nutritionValues] as String) as List<dynamic>).cast<double>(),



  );

  /*
    Creates json from String keys and object values
   */
  Map<String, dynamic> toJson() => {
      FoodFields.id: id,
      FoodFields.name: name,
      FoodFields.imageUrl: imageUrl,
      FoodFields.nutritionValues: jsonEncode(nutritionValues),
  };

  /*
    Creates a copy of Food object based on data given nutritionValues is a shallow copy
   */
  Food copy({
    int? id,
    String? name,
    String? imageUrl,
    List<double>? nutritionValues,
  }) =>
      Food(
          id: id ?? this.id,
          name: name ?? this.name,
          imageUrl: imageUrl ?? this.imageUrl,
          nutritionValues: nutritionValues ?? this.nutritionValues,

      );
  @override
  /*
    String representation of object
   */
  String toString() {
    return 'Food: {name: ${name}, imageUrl: ${imageUrl}, nutritionValues: ${nutritionValues}';
  }

  /*
    Getter methods for attributes besides id for Food object
   */
  String getName() {return this.name;}
  String getImageUrl(){return this.imageUrl;}
  List<double> getNutritionValues() {return this.nutritionValues;}
}