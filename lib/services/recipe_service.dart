import 'package:flutter/material.dart';
import 'package:recipe_app/entities/recipe.dart';
import 'package:recipe_app/repositories/recipe_repository.dart';

class RecipeService extends ChangeNotifier {
  final RecipeRepository repository = RecipeRepository();

  List<Recipe> _recipes = [];
  bool _isLoading = true;

  List<Recipe> get findAll => _recipes;
  bool get isLoading => _isLoading;

  RecipeService() {
    Future.microtask(() => loadRecipes());
  }

  Future<void> loadRecipes() async {
    _isLoading = true;
    notifyListeners();

    _recipes = await repository.findAll();

    _isLoading = false;
    notifyListeners();
  }

  Future<Recipe?> findById(int id) async {
    return await repository.findById(id);
  }

  Future<void> create(Recipe obj) async {
    await repository.create(obj);
    await loadRecipes();
  }

  Future<void> update(Recipe obj) async {
    await repository.update(obj);
    await loadRecipes();
  }

  Future<void> delete(int id) async {
    await repository.delete(id);
    await loadRecipes();
  }
}