import 'dart:convert';

import 'package:flutter/material.dart';
/*
 User class stores user information from the food added
 */
class User{
  /*
    allNutritionNames Contains the names of all the separate nutrition types
    allUnits Contains the corresponding units for the nutrition types
    totalNutrition Contains the values of the amount of intake from each nutrition type
    percentages Contains the percentages that were intake based on the daily nutrition recommendations
   */
  List<String> allNutritionNames;
  List<String> allUnits;
  List<double> totalNutrition;
  List<double> percentages;
  /*
    Constructor for user
   */
  User({required this.allNutritionNames, required this.allUnits, required this.totalNutrition, required this.percentages});



  /*
    Getter methods for each attribute of the user
   */
  List<String> getAllNutritionNames() {return this.allNutritionNames;}
  List<String> getAllUnits() {return this.allUnits;}
  List<double> getTotalNutrition() {return this.totalNutrition;}
  List<double> getPercentages() {return this.percentages;}

  factory User.fromJson(Map<String, dynamic> json){
    final names = (json['allNutritionNames'].map<String>((name) => name as String).toList());
    final units = (json['allUnits'].map<String>((name) => name as String).toList());
    final nutrition = (json['totalNutrition'].map<double>((name) => name as double).toList());
    final percentages = (json['percentages'].map<double>((name) => name as double).toList());
    return User(
      allNutritionNames: names,
      allUnits: units,
      totalNutrition: nutrition,
      percentages: percentages
    );




  }
  Map<String, dynamic> toJson() => {
    'allNutritionNames': allNutritionNames,
    'allUnits': allUnits,
    'totalNutrition': totalNutrition,
    'percentages': percentages,
  };

}