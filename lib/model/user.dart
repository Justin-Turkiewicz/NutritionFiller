import 'package:flutter/material.dart';
class User{

  List<String> allNutritionNames;
  List<String> allUnits;
  List<double> totalNutrition;
  List<double> percentages;

  User({required this.allNutritionNames, required this.allUnits, required this.totalNutrition, required this.percentages});

  List<String> getAllNutritionNames() {return this.allNutritionNames;}
  List<String> getAllUnits() {return this.allUnits;}
  List<double> getTotalNutrition() {return this.totalNutrition;}
  List<double> getPercentages() {return this.percentages;}

}