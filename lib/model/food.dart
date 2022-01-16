import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
final String tableFoods = 'foods';
class FoodFields{
  static final List<String> values = [
    id, name, imageUrl, nutritionValues
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String imageUrl = 'imageUrl';
  static final String nutritionValues = 'nutritionValues';

}
class Food{
  int? id;
  late String name;
  late String imageUrl;
  late List<double> nutritionValues;



  Food({this.id, required this.name, required this.imageUrl, required this.nutritionValues});

  Food.fromMap(dynamic obj){
    this.id = obj['id'];
    this.name = obj['name'];
    this.imageUrl = obj['imageUrl'];
    this.nutritionValues = obj['nutritionValues'];
  }



  static Food fromJson(Map<String, Object?> json) => Food(
      id: json[FoodFields.id] as int?,
      name: json[FoodFields.name] as String,
      imageUrl: json[FoodFields.imageUrl] as String,
      nutritionValues: (jsonDecode(json[FoodFields.nutritionValues] as String) as List<dynamic>).cast<double>(),



  );



  Map<String, Object?> toJson() => {
      FoodFields.id: id,
      FoodFields.name: name,
      FoodFields.imageUrl: imageUrl,
      FoodFields.nutritionValues: jsonEncode(nutritionValues),
  };

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
  String toString() {
    return 'Food: {name: ${name}, imageUrl: ${imageUrl}, nutritionValues: ${nutritionValues}';
  }

  String getName() {return this.name;}
  String getImageUrl(){return this.imageUrl;}
  List<double> getNutritionValues() {return this.nutritionValues;}
}