import 'dart:convert';
import 'package:recipe_app/entities/preparation_step.dart';
import 'package:recipe_app/entities/recipe_ingredient.dart';

class Recipe {
  final int id;
  final String name;
  final double rate;
  final DateTime addedDate;
  final int preparationTimeMinutes;

  final List<RecipeIngredient> ingredients;
  final List<PreparationStep> steps;

  Recipe({required this.id, required this.name, required this.rate, required this.addedDate, required this.preparationTimeMinutes, this.ingredients = const [], this.steps = const []});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'rate': rate,
      'added_date': addedDate.millisecondsSinceEpoch,
      'preparation_time_minutes': preparationTimeMinutes,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as int,
      name: map['name'] as String,
      rate: map['rate'] as double,
      addedDate: DateTime.fromMillisecondsSinceEpoch(map['added_date'] as int),
      preparationTimeMinutes: map['preparation_time_minutes'] as int,
      ingredients: (map['recipe_ingredients'] as List<dynamic>?)
              ?.map((ingredient) => RecipeIngredient.fromMap(ingredient))
              .toList() ??
          [],
      steps: (map['preparation_steps'] as List<dynamic>?)
              ?.map((step) => PreparationStep.fromMap(step))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source) as Map<String, dynamic>);
}