import 'package:flutter/material.dart';
import 'package:food_task/models/individual_meal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchRandom extends StatefulWidget {
  const FetchRandom({super.key});
  static const routeName = '/fetch-random';

  @override
  State<FetchRandom> createState() => _FetchRandomState();
}

class _FetchRandomState extends State<FetchRandom> {
  List<IndividualMeal> mealList = [];
  Future<List<IndividualMeal>?> getRandomList() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
      );
      var data = jsonDecode(response.body.toString());
      print(data['meals'][0]['strInstructions']);
      if (response.statusCode == 200) {
        mealList.add(IndividualMeal.fromJson(data));

        return mealList;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text('Random Meal'),
      ),
      body: FutureBuilder(
          future: getRandomList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Image.network(
                    mealList[0].meals?[0].strMealThumb ?? 'no image available',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 250,
                    width: 300,
                    child: ListView.builder(
                      itemCount: mealList.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          tileColor: Colors.white,
                          textColor: Colors.black,
                          subtitle: Text(
                            mealList[0].meals?[0].strInstructions ??
                                'no instructions available',
                          ),
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
