import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:nutrtionfiller/model/food.dart';
import 'package:nutrtionfiller/model/user.dart';
/*
  This page displays the user's intake for each seperate nutrition value
 */
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  /*
    userData Gets data from add_food page
    nutritionNames Contains the nutrition names
    nutritionUnits Contains the corresponding nutrition units
    nutritionValues Contains the starting values for the nutrition values
    percentages Contains the starting percentages for the nutrition percentages
    emptyValues Used to reset user's nutrition values for clear button
    emptyPercentages Used to reset user's percentages for clear button
    user User object with its attributes displayed on the page
    AMOUNTOFNUTRITIONVALUES Constant for the amount of different nutrition types
    DAILYVALUEPERCENTAGES Constant for the daily nutrition values to be used to calculate percentage with user's values
    lastFoodQueue First food in queue was the last food added
    foodAddedQueue Stores all the food added to the user
   */
  Map userData ={};
  List<String> nutritionNames = ['Calories', 'Total Fat', 'Saturated Fat', 'Cholesterol', 'Sodium', 'Potassium', 'Carbohydrate', 'Dietary Fiber', 'Sugar', 'Protein', 'Calcium', 'Iron', 'Zinc', 'Magnesium', 'Phosphorus', 'Vitamin A', 'Vitamin B-6', 'Vitamin B-12', 'Vitamin C', 'Vitamin E', 'Vitamin K'];
  List<String> nutritionUnits = ['cal', 'g', 'g', 'mg', 'mg', 'mg', 'g', 'g', 'g', 'g', 'mg', 'mg', 'mg', 'mg', 'mg', 'mcg', 'mg', 'mcg', 'mg', 'mg', 'mcg'];
  List<double> nutritionValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> percentages = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> emptyValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> emptyPercentages = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  late User user;
  final int AMOUNTOFNUTRITIONVALUES = 21;
  final List<double> DAILYVALUEPERCENTAGES = [2000.0, 78.0, 20.0, 300.0, 2300.0, 4700.0, 275.0, 28.0, 50.0, 50.0, 1300.0, 18.0, 11.0, 420.0, 1250.0, 900.0, 1.7, 2.4, 90.0, 15.0, 120.0];
  Queue<Food> lastFoodQueue = Queue<Food>();
  Queue<Food> foodAddedQueue = Queue<Food>();

  /*
    Gets the food queue from the add_food page, if not empty changes
    the user's nutrition values and percentages
   */
  void retrieveData() async{
    dynamic foodAdded = await Navigator.pushNamed(context, '/add_food');
      setState(() {
      userData = {
        'nutritionValues': foodAdded['nutritionValues'],
      };
      foodAddedQueue = userData['nutritionValues'];
      if(foodAdded['nutritionValues'] != null) {
        editValues();
      }
      });
  }

  /*
    Adds each Food object's nutrition values to the user's nutritionValues and updates the
    percentages. Each Food object from foodAdded queue to lastFoodQueue
   */
  void editValues() {
    int foodIndex = 0;
    while (foodAddedQueue.isNotEmpty) {
      lastFoodQueue.add(foodAddedQueue.removeLast());
      for (int index = 0; index < AMOUNTOFNUTRITIONVALUES; index++) {
        user.getTotalNutrition()[index] += lastFoodQueue
            .elementAt(foodIndex)
            .nutritionValues[index];
        user.getPercentages()[index] =
        (user.getTotalNutrition()[index] / DAILYVALUEPERCENTAGES[index]);
        user.getTotalNutrition()[index] =
            double.parse((user.getTotalNutrition()[index]).toStringAsFixed(1));
        user.getPercentages()[index] =
            double.parse((user.getPercentages()[index]).toStringAsFixed(2));
      }
      foodIndex++;
    }
  }
  /*
    Instantiated user
   */
  @override
  void initState() {
      super.initState();
      user = User(allNutritionNames: nutritionNames, allUnits: nutritionUnits, totalNutrition: nutritionValues, percentages: percentages);
  }

  /*
    Removes last food based on the lastFoodQueue(First food in queue was the last food added)
   */
  void removeLastFood() {
    if(lastFoodQueue.isNotEmpty) {
      Food lastFood = lastFoodQueue.removeFirst();
      for (int index = 0; index < AMOUNTOFNUTRITIONVALUES; index++) {
        user.totalNutrition[index] -= lastFood.nutritionValues[index];
        user.getPercentages()[index] =
        (user.getTotalNutrition()[index] / DAILYVALUEPERCENTAGES[index]);
        /*
          Makes sure user's nutrition values and percentages don't go below 0
         */
        if (user.totalNutrition[index] < 0) {
          user.totalNutrition[index] = 0.0;
          user.getPercentages()[index] = 0.0;
        }
        else {
          user.getTotalNutrition()[index] = double.parse(
              (user.getTotalNutrition()[index]).toStringAsFixed(1));
          user.getPercentages()[index] =
              double.parse((user.getPercentages()[index]).toStringAsFixed(2));
        }
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
          AppBar allows navigation to add_food page, clear user's data and remove last food from user data
         */
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red[700],
          title: Text('Your Progress', style: TextStyle(color: Color(0xff1b5e20)),),
          leading: Builder(
            builder: (BuildContext context){
              return IconButton(onPressed: () {
                //Navigator.pushNamedAndRemoveUntil(context, '/add_food', (route) => false);
                retrieveData();}, icon: Icon(Icons.arrow_back));
            },
          ),
          actions: <Widget>[
            /*
              Creates clear button
             */
            Container(
              width: 50,
              child: Builder(builder: (BuildContext context) {
                return IconButton(onPressed: () {
                  setState(() {
                    user = User(allNutritionNames: nutritionNames, allUnits: nutritionUnits, totalNutrition: emptyValues, percentages: emptyPercentages);
                  });
                }, icon: Text('Clear', style: TextStyle(fontSize: 13),),);
              }),
            ),
            /*
              Creates remove last food button
             */
            Container(
              width: 100,
              child: Builder(builder: (BuildContext context) {
                return IconButton(onPressed: () {
                  setState(() {
                    removeLastFood();
                  });
                }, icon: Text('Remove Last Food', style: TextStyle(fontSize: 13),),);
              }),
            )
          ],


          ),
        /*
          Builds the tiles for each nutrition type of the user
         */
        body: ListView.builder(
              itemCount: user.getTotalNutrition().length,
              itemBuilder: (context, index){
                return Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Card(
                    child: ListTile(
                        title: Text(user.getAllNutritionNames()[index]+': '+user.getTotalNutrition()[index].toString()+' '+user.getAllUnits()[index]),
                        trailing: Wrap(
                            spacing: 12.0,
                            children: <Widget>[
                              Text((user.getPercentages()[index]*100).round().toString()+'%'),
                              Container(width: 150, child: LinearProgressIndicator(value: user.getPercentages()[index]>1.0 ? 1.0 : user.getPercentages()[index])),


                              ],),
                    ),

                  ),
                );
              },

          ),






    );

  }
}
