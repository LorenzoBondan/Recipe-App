import 'package:flutter/material.dart';
import 'package:recipe_app/entities/recipe_ingredient.dart';
import 'package:recipe_app/repositories/recipe_ingredient_repository.dart';

class RecipeIngredientService extends ChangeNotifier {
  final RecipeIngredientRepository repository = RecipeIngredientRepository();

  List<RecipeIngredient> _recipeIngredients = [];
  bool _isLoading = true;

  List<RecipeIngredient> get findAll => _recipeIngredients;
  bool get isLoading => _isLoading;

  RecipeIngredientService() {
    Future.microtask(() => loadRecipeIngredients());
  }

  Future<void> loadRecipeIngredients() async {
    _isLoading = true;
    notifyListeners();

    _recipeIngredients = await repository.findAll();

    _isLoading = false;
    notifyListeners();
  }

  Future<List<RecipeIngredient>> findByRecipeId(int recipeId) async {
    return await repository.findByRecipeId(recipeId);
  }

  Future<RecipeIngredient?> findById(int id) async {
    return await repository.findById(id);
  }

  Future<void> create(RecipeIngredient obj) async {
    await repository.create(obj);
    await loadRecipeIngredients();
  }

  Future<void> update(RecipeIngredient obj) async {
    await repository.update(obj);
    await loadRecipeIngredients();
  }

  Future<void> delete(int id) async {
    await repository.delete(id);
    await loadRecipeIngredients();
  }
}