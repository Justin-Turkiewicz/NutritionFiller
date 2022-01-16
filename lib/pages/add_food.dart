import 'dart:io';
import 'dart:ui';
import 'package:nutrtionfiller/db/food_database.dart';
import 'package:nutrtionfiller/model/FoodSearchDelegate.dart';
import 'package:nutrtionfiller/model/food.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
class Add_Food extends StatefulWidget {
  const Add_Food({Key? key}) : super(key: key);

  @override
  _Add_FoodState createState() => _Add_FoodState();
}

class _Add_FoodState extends State<Add_Food> {

  List<List<double>> nutritionValues = [

    [101.0, 5.74, 0.788, 0.0, 234.0, 260.0, 9.84, 5.51, 2.7, 5.7, 60.8, 1.14, 0.513, 24.7, 89.3, 93.1, 0.239, 0.0, 73.7, 3.08, 169.0]
  ];
  List<String> nutritionNames = ['Calories', 'Total Fat', 'Saturated Fat', 'Cholesterol', 'Sodium', 'Potassium', 'Carbohydrate', 'Dietary Fiber', 'Sugar', 'Protein', 'Calcium', 'Iron', 'Zinc', 'Magnesium', 'Phosphorus', 'Vitamin A', 'Vitamin B-6', 'Vitamin B-12', 'Vitamin C', 'Vitamin E', 'Vitamin K'];
  List<String> nutritionUnits = ['cal', 'g', 'g', 'mg', 'mg', 'mg', 'g', 'g', 'g', 'g', 'mg', 'mg', 'mg', 'mg', 'mg', 'mcg', 'mg', 'mcg', 'mg', 'mg', 'mcg'];
  List<double> allFoodValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> lastFoodValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  late double amount;
  bool foodAdded = false;
  late Food food;
  final int amountOfNutritionValues = 21;
  FoodDatabase foodDatabase = FoodDatabase.instance;
  final addController = TextEditingController();
  late Database database;
  List<Food> foodList = [];
  Food? selectedFood = null;

  @override
  void initState() {
    getFoodList();
    super.initState();
    food = Food(name: 'Brocolli', imageUrl: 'brocolli.jpg', nutritionValues: nutritionValues[0]);

  }

  void getFoodList() async{
    foodList = await foodDatabase.readAllFoods();
  }


  @override
  void dispose(){
    addController.dispose();
    super.dispose();
  }

  void multiply(@required double amount) {
      for(int index=0;index < amountOfNutritionValues;index++ ){
          lastFoodValues[index] = 0.0;
          allFoodValues[index] += (food.getNutritionValues()[index]*amount);
          lastFoodValues[index] = food.getNutritionValues()[index]*amount;
      }
      foodAdded = true;

  }
  void addFood(){
      if(foodAdded) {
        Navigator.pop(context, {
          'nutritionValues': allFoodValues,
          'lastFoodValues': lastFoodValues
        });
      }
      else{
        Navigator.pop(context, {

        });
      }
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.red[700],
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(onPressed: () {
                  addFood();
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 200.0, 0.0),
                            child: Text(food.getName(), style: TextStyle(color: Colors.grey[900], fontSize: 30, fontFamily: 'CormorantGaramond'),),
                          ),
                        Container(
                          height: 100,
                          width: 100,
                          child: Image.asset('assets/images/${food.imageUrl}'),
                        ),],
                        ),
                         for(int index=0; index < amountOfNutritionValues;index++)
                             Text(nutritionNames[index]+': '+food.nutritionValues[index].toString()+' '+nutritionUnits[index], style: TextStyle(fontSize: 20.0,  fontWeight: FontWeight.bold,),),
                        const SizedBox(height: 50.0),
                        Row(

                          children: <Widget>[
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
                            RaisedButton(
                                child: Text('Add'),
                                onPressed: () {
                                try{multiply(double.parse(addController.text));}
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
// title: Container(
//   width: MediaQuery.of(context).size.width - 100.0,
//   child: TextField(
//     decoration: InputDecoration(
//       hintText: 'Search Foods'
//     ),
//     onChanged: (String text) async {
//       database = await foodDatabase.database;
//       List<Map> searchedFoods = await database.rawQuery(
//           "SELECT * FROM foods WHERE name LIKE '%${text}%'");
//       print(searchedFoods);
//     },
//   ),
//
//
// ),