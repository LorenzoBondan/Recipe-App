import 'package:flutter/material.dart';
import 'package:recipe_app/entities/preparation_step.dart';
import 'package:recipe_app/repositories/preparation_step_repository.dart';

class PreparationStepService extends ChangeNotifier {
  final PreparationStepRepository repository = PreparationStepRepository();

  List<PreparationStep> _preparationSteps = [];
  bool _isLoading = true;

  List<PreparationStep> get findAll => _preparationSteps;
  bool get isLoading => _isLoading;

  PreparationStepService() {
    Future.microtask(() => loadPreparationSteps());
  }

  Future<void> loadPreparationSteps() async {
    _isLoading = true;
    notifyListeners();

    _preparationSteps = await repository.findAll();

    _isLoading = false;
    notifyListeners();
  }

  Future<List<PreparationStep>> findByRecipeId(int recipeId) async {
    return await repository.findByRecipeId(recipeId);
  }

  Future<PreparationStep?> findById(int id) async {
    return await repository.findById(id);
  }

  Future<void> create(PreparationStep obj) async {
    await repository.create(obj);
    await loadPreparationSteps();
  }

  Future<void> update(PreparationStep obj) async {
    await repository.update(obj);
    await loadPreparationSteps();
  }

  Future<void> delete(int id) async {
    await repository.delete(id);
    await loadPreparationSteps();
  }
}