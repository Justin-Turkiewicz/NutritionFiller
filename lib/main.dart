import 'package:flutter/material.dart';
import 'package:nutrtionfiller/pages/add_food.dart';
import 'package:nutrtionfiller/pages/home.dart';
/*
    This application allows the user to track their intake based on many nutrition
    categories and see their progress. User has basic functionality of adding foods
    to intake, removing the last one added and clearing their intake.
    -Justin Turkiewicz 01/17/2022
 */
void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/add_food': (context) => Add_Food(),
    },
  ));
}