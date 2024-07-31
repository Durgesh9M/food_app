import 'package:flutter/material.dart';
import 'package:food_task/fetch_random.dart';
import 'package:food_task/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_task/screens/individual_meal_screen.dart';
import 'package:food_task/screens/login_screen.dart';
import 'package:food_task/screens/meals_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(color: Colors.orange.shade100),
      ),
      home: LoginScreen(),
      routes: {
        HomePage.routeName: (ctx) => const HomePage(),
        MealsScreen.routeName: (ctx) => const MealsScreen(),
        IndividualMealScreen.routeName: (ctx) => const IndividualMealScreen(),
        FetchRandom.routeName: (ctx) => const FetchRandom(),
      },
    );
  }
}
