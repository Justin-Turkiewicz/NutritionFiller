import 'dart:io';
import 'package:flutter/material.dart';
import 'food.dart';

/*
 FoodSearchDelegate class is used for the search function
 */
class FoodSearchDelegate extends SearchDelegate {
  /*
    allFoods Contains all the possible foods in the database
    suggestedFoods Contains the suggested foods based on what user typed
    resultFood Is the Food the user selected
   */
  final List<Food> allFoods;
  final List<Food> suggestedFoods;
  late Food resultFood;

  /*
    Constructor
   */
  FoodSearchDelegate({required this.allFoods, required this.suggestedFoods});

  /*
    Makes the clear button to remove the user's text input
   */
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

  /*
    Makes the back button to allow the user to exit the search delegate
   */
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

  /*
    Gets the results after the user has submitted a text input
   */
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

  /*
    Updates the suggestions to the user based on their text input
   */
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