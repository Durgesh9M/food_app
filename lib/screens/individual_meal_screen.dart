import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:food_task/models/individual_meal.dart';

class IndividualMealScreen extends StatefulWidget {
  const IndividualMealScreen({super.key});
  static const routeName = '/individual-meal-screen';

  @override
  State<IndividualMealScreen> createState() => _IndividualMealScreenState();
}

class _IndividualMealScreenState extends State<IndividualMealScreen> {
  List<dynamic> singleMealList = [];

  Future<List<dynamic>?> getSingleMealList() async {
    final meal = ModalRoute.of(context)?.settings.arguments as Map;
    final mealId = meal['id'];

    try {
      final response = await http.get(
        Uri.parse(
            'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId'),
      );
      var data = jsonDecode(response.body.toString())['meals'];
      // print(data);
      if (response.statusCode == 200) {
        singleMealList = data.map((item) => item.toString()).toList();
        return singleMealList;
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
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map;
    final mealName = routeArgs['name'];
    final imageUrl = routeArgs['image'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          mealName,
          style: TextStyle(fontSize: 15.0),
        ),
      ),
      body: FutureBuilder(
          future: getSingleMealList(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    child: Image.network(
                      imageUrl,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 250,
                    width: 300,
                    child: ListView.builder(
                      itemCount: singleMealList.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          tileColor: Colors.white,
                          textColor: Colors.black,
                          subtitle: Text(singleMealList[index]),
                        );
                      },
                    ),
                  )
                ],
              );
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
