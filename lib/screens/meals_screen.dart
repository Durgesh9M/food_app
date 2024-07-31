import 'package:flutter/material.dart';
import 'package:food_task/models/category_meals.dart';
import 'package:food_task/screens/individual_meal_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});
  static const routeName = '/meals-screen';

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<Meal> mealList = [];
  Future<List<Meal>?> getMealsList() async {
    final categoryName = ModalRoute.of(context)?.settings.arguments;
    try {
      final response = await http.get(
        Uri.parse(
            'https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName'),
      );
      var data = jsonDecode(response.body.toString())['meals'];
      // print(data);
      if (response.statusCode == 200) {
        for (Map<String, dynamic> i in data) {
          mealList.add(Meal.fromJson(i));
        }
        return mealList;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text('Meals'),
      ),
      body: FutureBuilder(
          future: getMealsList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: mealList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            IndividualMealScreen.routeName,
                            arguments: {
                              'id': mealList[index].idMeal,
                              'name': mealList[index].strMeal,
                              'image': mealList[index].strMealThumb,
                            });
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              mealList[index].strMealThumb.toString()),
                          // child: Image.network(
                          //     mealList[index].strMealThumb.toString()),
                        ),
                        title: Text(mealList[index].strMeal.toString()),
                        subtitle:
                            Text('Id: ${mealList[index].idMeal.toString()}'),
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
          }),
    );
  }
}
