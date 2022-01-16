import 'package:flutter/material.dart';
import 'package:nutrtionfiller/pages/add_food.dart';
import 'package:nutrtionfiller/pages/home.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/add_food': (context) => Add_Food(),
    },
  ));
}