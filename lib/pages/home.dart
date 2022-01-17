import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nutrtionfiller/model/food.dart';
import 'package:nutrtionfiller/model/user.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map userData ={};
  List<String> nutritionNames = ['Calories', 'Total Fat', 'Saturated Fat', 'Cholesterol', 'Sodium', 'Potassium', 'Carbohydrate', 'Dietary Fiber', 'Sugar', 'Protein', 'Calcium', 'Iron', 'Zinc', 'Magnesium', 'Phosphorus', 'Vitamin A', 'Vitamin B-6', 'Vitamin B-12', 'Vitamin C', 'Vitamin E', 'Vitamin K'];
  List<String> nutritionUnits = ['cal', 'g', 'g', 'mg', 'mg', 'mg', 'g', 'g', 'g', 'g', 'mg', 'mg', 'mg', 'mg', 'mg', 'mcg', 'mg', 'mcg', 'mg', 'mg', 'mcg'];
  List<double> nutritionValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> percentages = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> emptyValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> emptyPercentages = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> lastFoodValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  late User user;
  final int amountOfNutritionValues = 21;
  final List<double> dailyValuePercentages = [2000.0, 78.0, 20.0, 300.0, 2300.0, 4700.0, 275.0, 28.0, 50.0, 50.0, 1300.0, 18.0, 11.0, 420.0, 1250.0, 900.0, 1.7, 2.4, 90.0, 15.0, 120.0];
  Queue<Food> lastFoodQueue = Queue<Food>();
  Queue<Food> foodAddedQueue = Queue<Food>();
  void retrieveData() async{
    dynamic foodAdded = await Navigator.pushNamed(context, '/add_food');
      setState(() {
      userData = {
        'nutritionValues': foodAdded['nutritionValues'],
        'foodAdded': foodAdded['foodAdded']
      };
      foodAddedQueue = userData['nutritionValues'];
      if(foodAdded['nutritionValues'] != null) {
        editValues();
      }
      });
  }

  void editValues() {
    int foodIndex = 0;
    while (foodAddedQueue.isNotEmpty) {
      lastFoodQueue.add(foodAddedQueue.removeLast());
      for (int index = 0; index < amountOfNutritionValues; index++) {
        user.getTotalNutrition()[index] += lastFoodQueue
            .elementAt(foodIndex)
            .nutritionValues[index];
        user.getPercentages()[index] =
        (user.getTotalNutrition()[index] / dailyValuePercentages[index]);
        user.getTotalNutrition()[index] =
            double.parse((user.getTotalNutrition()[index]).toStringAsFixed(1));
        user.getPercentages()[index] =
            double.parse((user.getPercentages()[index]).toStringAsFixed(2));
      }
      foodIndex++;
    }
  }
  @override
  void initState() {
      super.initState();
      user = User(allNutritionNames: nutritionNames, allUnits: nutritionUnits, totalNutrition: nutritionValues, percentages: percentages);
  }

  void removeLastFood() {
    if(lastFoodQueue.isNotEmpty) {
      Food lastFood = lastFoodQueue.removeFirst();
      for (int index = 0; index < amountOfNutritionValues; index++) {
        user.totalNutrition[index] -= lastFood.nutritionValues[index];
        user.getPercentages()[index] =
        (user.getTotalNutrition()[index] / dailyValuePercentages[index]);
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
