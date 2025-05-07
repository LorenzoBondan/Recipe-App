import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/repositories/database_helper.dart';
import 'package:recipe_app/services/preparation_step_service.dart';
import 'package:recipe_app/services/random_service.dart';
import 'package:recipe_app/services/recipe_ingredient_service.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/view/recipe/recipe_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeService()),
        ChangeNotifierProvider(create: (_) => RecipeIngredientService()),
        ChangeNotifierProvider(create: (_) => PreparationStepService()),
        ChangeNotifierProvider(create: (_) => RandomService())
      ],
      child: MaterialApp(
        title: 'Recipe App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const RecipeListPage(),
      ),
    );
  }
}
