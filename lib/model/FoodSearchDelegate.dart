import 'dart:io';

import 'package:flutter/material.dart';

import 'food.dart';

class FoodSearchDelegate extends SearchDelegate {
  final List<Food> allFoods;
  final List<Food> suggestedFoods;
  late Food resultFood;

  FoodSearchDelegate({required this.allFoods, required this.suggestedFoods});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return
      IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, query);
        },
      );
    ;
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Food> allResults = allFoods.where((food) =>
        food.name.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
        itemCount: allResults.length,
        itemBuilder: (context, index) =>
            ListTile(title:
              Text(allResults[index].name),
                onTap: () {
                  resultFood = allResults[index];
                  close(context, resultFood);
                }
            ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Food> allSuggestions = suggestedFoods.where((food) =>
        food.name.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: allSuggestions.length,
      itemBuilder: (context, index) =>
          ListTile(
              title: Text(allSuggestions[index].name),

              onTap: () {
                resultFood = allSuggestions[index];
                close(context, resultFood);
              }
          ),
    );
  }
}