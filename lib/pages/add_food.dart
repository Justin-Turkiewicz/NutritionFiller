import 'dart:collection';
import 'dart:io';
import 'dart:ui';
import 'package:nutrtionfiller/db/food_database.dart';
import 'package:nutrtionfiller/model/FoodSearchDelegate.dart';
import 'package:nutrtionfiller/model/food.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
/*
  This page allows the user to view the nutrition facts for particular
  foods and add food to their intake based on a serving size by cups
 */
class Add_Food extends StatefulWidget {
  const Add_Food({Key? key}) : super(key: key);

  @override
  _Add_FoodState createState() => _Add_FoodState();
}

class _Add_FoodState extends State<Add_Food> {

  /*
    nutritionNames Contains the nutrition names to be displayed on the page
    nutritionUnits Contains the nutrition units to be displayed on the page
    amount Used for getting the user input from the amount of cups eaten
    food Food object currently displayed on the page
    foodDatabase Gets the food database
    addController Used to translate user input to the amount variable
    database The foods.db file of the table foods
    foodList Contains all the foods from the database and is used to allow the user to select from search function
    allAddedFood Contains a queue of all the food added during time on page. Then sent to home page
   */
  List<String> nutritionNames = ['Calories', 'Total Fat', 'Saturated Fat', 'Cholesterol', 'Sodium', 'Potassium', 'Carbohydrate', 'Dietary Fiber', 'Sugar', 'Protein', 'Calcium', 'Iron', 'Zinc', 'Magnesium', 'Phosphorus', 'Vitamin A', 'Vitamin B-6', 'Vitamin B-12', 'Vitamin C', 'Vitamin E', 'Vitamin K'];
  List<String> nutritionUnits = ['cal', 'g', 'g', 'mg', 'mg', 'mg', 'g', 'g', 'g', 'g', 'mg', 'mg', 'mg', 'mg', 'mg', 'mcg', 'mg', 'mcg', 'mg', 'mg', 'mcg'];
  late double amount;
  late Food food;
  final int amountOfNutritionValues = 21;
  FoodDatabase foodDatabase = FoodDatabase.instance;
  final addController = TextEditingController();
  late Database database;
  List<Food> foodList = [];
  Food? selectedFood = null;
  Queue<Food> allAddedFood = Queue<Food>();
  /*
    Makes sure foodList is populated, initial food to be displayed to Broccoli and
    allAddedFood queue is clear
   */
  @override
  void initState() {
    getFoodList();
    super.initState();
    food = Food(name: 'Broccoli', imageUrl: 'broccoli.jpg', nutritionValues: foodList[0].nutritionValues);
    allAddedFood.clear();
  }

  /*
    Populates foodList
   */
  void getFoodList() async{
    foodList = await foodDatabase.readAllFoods();
  }


  @override
  /*
    Gets rid of addController's value
   */
  void dispose(){
    addController.dispose();
    super.dispose();
  }

  /*
    Deep clones a Food object of current Food object displayed
    then changes the cloned Food object's nutrition values based
    on amount inputted then adds to queue
   */
  void addFood(@required double amount) {
    Food foodToBeAdded = Food.clone(food);
    print(foodToBeAdded.toString());
      for(int index=0;index < amountOfNutritionValues;index++){
          foodToBeAdded.nutritionValues[index] *= amount;
      }
      print(foodToBeAdded.toString());
      allAddedFood.add(foodToBeAdded);

  }
  /*
    Sends the queue to home page to be processed
   */
  void sendToHome(){
        Navigator.pop(context, {
          'nutritionValues': allAddedFood,
        });

  }

  /*
    Notifies user if the amount of cups they inputted is invalid(i.e. '1,,0')
   */
  Future alert(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context)
    {
      return AlertDialog(
        title: const Text('Invalid Amount'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Ok');
            },
            child: const Text('Ok'),
          ),
        ],
      );
    });
  }

  @override
  /*
    Builds page
   */
  Widget build(BuildContext context) {
    return Scaffold(
      /*
        appBar displays title and contains search function. Also allows user to
        go back to home page
       */
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.red[700],
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(onPressed: () {
                  sendToHome();
                }, icon: Icon(Icons.arrow_back));
              },),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async{
                  final result = await showSearch(context: context, delegate: FoodSearchDelegate(allFoods: foodList,
                  suggestedFoods: foodList));
                  setState(() {
                    selectedFood = result;
                    food = selectedFood!;
                  });
                },
              )
            ],
          ),
          /*
            Builds body of page. Scrollable
           */
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                        children: <Widget>[
                          /*
                            Formats the food name
                           */
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                              child: Container(
                                  width: 275,
                                  height: 60,
                                  child: Text(
                                    food.getName(),
                                    style: TextStyle(color: Colors.grey[900], fontSize: 30, fontFamily: 'CormorantGaramond'),
                                  )
                              ),
                            ),
                        /*
                        Formats the food image
                         */
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                          child: Container(
                            height: 60,
                            width: 100,
                            child: Image.asset('assets/images/${food.imageUrl}', height:60, width: 100, fit: BoxFit.fitHeight,),
                          ),
                        ),],
                        ),
                         /*
                            Generates the food's nutrition facts to the user
                          */
                         for(int index=0; index < amountOfNutritionValues;index++)
                             Text(nutritionNames[index]+': '+food.nutritionValues[index].toString()+' '+nutritionUnits[index], style: TextStyle(fontSize: 20.0,  fontWeight: FontWeight.bold,),),
                        const SizedBox(height: 50.0),
                        Row(

                          children: <Widget>[
                            /*
                               Creates user text field for input
                             */
                            Container(
                              width: 200.0,
                              child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter amount in cup(s)',
                              ),
                              selectionWidthStyle: BoxWidthStyle.tight,
                              controller: addController,
                              keyboardType: TextInputType.number,
                            ),),
                            /*
                              Creates the add button for user
                             */
                            RaisedButton(
                                child: Text('Add'),
                                onPressed: () {
                                try{addFood(double.parse(addController.text));}
                                on FormatException {
                                  setState(() {

                                    alert(context);
                                  });
                                };
                              //addFood();

                              }),

                          ],
                        ),
                      ],
                    ),
                    ),
            ),
          ),

      );

  }
}
