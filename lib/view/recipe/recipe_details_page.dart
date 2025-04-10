import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/entities/preparation_step.dart';
import 'package:recipe_app/entities/recipe.dart';
import 'package:recipe_app/entities/recipe_ingredient.dart';
import 'package:recipe_app/services/preparation_step_service.dart';
import 'package:recipe_app/services/recipe_ingredient_service.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/view/preparation_step/preparation_step_form_page.dart';
import 'package:recipe_app/view/preparation_step/preparation_step_list_page.dart';
import 'package:recipe_app/view/recipe/recipe_form_page.dart';
import 'package:recipe_app/view/recipe/recipe_list_page.dart';
import 'package:recipe_app/view/recipe_ingredient/recipe_ingredient_form_page.dart';
import 'package:recipe_app/view/recipe_ingredient/recipe_ingredient_list_page.dart';

class RecipeDetailsPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsPage({super.key, required this.recipe});

  @override
  RecipeDetailsPageState createState() => RecipeDetailsPageState();
}

class RecipeDetailsPageState extends State<RecipeDetailsPage> {
  late RecipeService service;
  late RecipeIngredientService recipeIngredientService;
  late List<RecipeIngredient> ingredients;
  late PreparationStepService preparationStepService;
  late List<PreparationStep> steps;

  @override
  void initState() {
    super.initState();
    service = Provider.of<RecipeService>(context, listen: false);
    recipeIngredientService = Provider.of<RecipeIngredientService>(context, listen: false);
    _loadRecipeIngredients();
    preparationStepService = Provider.of<PreparationStepService>(context, listen: false);
    _loadPreparationSteps();
  }

  Future<void> _loadRecipeIngredients() async {
    List<RecipeIngredient> ingredientsList = await recipeIngredientService.findByRecipeId(widget.recipe.id);
    setState(() {
      ingredients = ingredientsList;
    });
  }

  Future<void> _loadPreparationSteps() async {
    List<PreparationStep> stepsList = await preparationStepService.findByRecipeId(widget.recipe.id);
    setState(() {
      steps = stepsList;
    });
  }

  void _deleteRecipeIngredient(int recipeIngredientId) {
    recipeIngredientService.delete(recipeIngredientId);
    _loadRecipeIngredients();
  }

  void _deletePreparationStep(int preparationStepId) {
    preparationStepService.delete(preparationStepId);
    _loadPreparationSteps();
  }

  void _confirmDelete(BuildContext context, int recipeId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this Recipe?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<RecipeService>(context, listen: false).delete(recipeId);
                Navigator.pop(dialogContext);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeListPage()),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(widget.recipe.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 10),

            Text('Rate: ${widget.recipe.rate}', style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 10),

            Text('Preparation time: ${widget.recipe.preparationTimeMinutes} minutes', style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 10),

            Text('Ingredients', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            RecipeIngredientListPage(ingredients: ingredients, onDelete: _deleteRecipeIngredient, onEdit: _loadRecipeIngredients),
            
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeIngredientFormPage(recipeId: widget.recipe.id)),
                  );
                  _loadRecipeIngredients();
                },
              ),
            ),
            const SizedBox(height: 40),

            Text('Steps', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            PreparationStepListPage(steps: steps, onDelete: _deletePreparationStep, onEdit: _loadPreparationSteps),
            
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PreparationStepFormPage(recipeId: widget.recipe.id)),
                  );
                  _loadPreparationSteps();
                },
              ),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity, 
              child: 
                Center(
                  child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                            
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            iconColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RecipeFormPage(recipe: widget.recipe)),
                            );
                          },
                        ),

                        ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            iconColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () {
                            _confirmDelete(context, widget.recipe.id);
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            iconColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                    ],
                  ),
                )
              ),
          ],
        ),
      ),
    );
  }
}