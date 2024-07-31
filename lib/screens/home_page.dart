import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_task/fetch_random.dart';
import 'package:food_task/models/variety_list.dart';
import 'package:food_task/screens/meals_screen.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> catList = [];
  Future<List<Category>?> getCategoriesList() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
      );
      var data = jsonDecode(response.body.toString())['categories'];
      if (response.statusCode == 200) {
        for (Map<String, dynamic> i in data) {
          catList.add(Category.fromJson(i));
        }
        return catList;
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
        backgroundColor: Colors.orange.shade100,
        title: Text('Home Page'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_outlined,
                weight: 10.0,
              )),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(FetchRandom.routeName);
              },
              icon: const Icon(
                Icons.fastfood_rounded,
                weight: 10.0,
              ))
        ],
      ),
      body: FutureBuilder(
          future: getCategoriesList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  padding: EdgeInsets.all(10.0),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 200.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: catList.length,
                  itemBuilder: (_, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      width: 200,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(MealsScreen.routeName,
                              arguments: catList[index].strCategory.toString());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              catList[index].strCategoryThumb.toString(),
                            ),
                            Text(catList[index].strCategory.toString()),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
          }),
    );
  }
}
