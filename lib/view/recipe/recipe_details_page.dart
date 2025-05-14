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
import 'package:intl/intl.dart';

class RecipeDetailsPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsPage({super.key, required this.recipe});

  @override
  RecipeDetailsPageState createState() => RecipeDetailsPageState();
}

class RecipeDetailsPageState extends State<RecipeDetailsPage> {
  late RecipeService service = RecipeService();
  late RecipeIngredientService recipeIngredientService = RecipeIngredientService();
  late List<RecipeIngredient> ingredients = [];
  late PreparationStepService preparationStepService = PreparationStepService();
  late List<PreparationStep> steps = [];

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
    List<RecipeIngredient> ingredientsList = await recipeIngredientService.findByRecipeId(widget.recipe.id!);
    setState(() {
      ingredients = ingredientsList;
    });
  }

  Future<void> _loadPreparationSteps() async {
    List<PreparationStep> stepsList = await preparationStepService.findByRecipeId(widget.recipe.id!);
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Confirm Deletion',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this Recipe?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[800] ?? const Color.fromARGB(255, 66, 66, 66),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<RecipeService>(context, listen: false).delete(recipeId);
                Navigator.pop(dialogContext);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Delete'),
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
        title: const Text('Recipe Details', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.recipe.name, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.grey[900])),

            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_month, color: Colors.indigo[600], size: 20),
                const SizedBox(width: 4),
                Text.rich(
                  TextSpan(
                    text: 'Date: ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                    children: [
                      TextSpan(
                        text: DateFormat('MM/dd/yyyy').format(widget.recipe.addedDate),
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, color: Colors.green[800], size: 20),
                const SizedBox(width: 4),
                Text.rich(
                  TextSpan(
                    text: 'Preparation Time: ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                    children: [
                      TextSpan(
                        text: '${widget.recipe.preparationTimeMinutes} ${widget.recipe.preparationTimeMinutes == 1 ? "minute" : "minutes"}',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: Colors.amber[700], size: 20),
                const SizedBox(width: 4),
                Text.rich(
                  TextSpan(
                    text: 'Rating: ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                    children: [
                      TextSpan(
                        text: widget.recipe.rate.toString(),
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            Text('Ingredients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark)),
            RecipeIngredientListPage(ingredients: ingredients, onDelete: _deleteRecipeIngredient, onEdit: _loadRecipeIngredients),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // ADICIONAR
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Generate'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecipeIngredientFormPage(recipeId: widget.recipe.id)),
                      );
                      _loadRecipeIngredients();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Add'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            Text('Steps', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark)),
            PreparationStepListPage(steps: steps, onDelete: _deletePreparationStep, onEdit: _loadPreparationSteps),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // ADICIONAR
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Generate'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreparationStepFormPage(recipeId: widget.recipe.id)),
                      );
                      _loadPreparationSteps();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Add'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecipeFormPage(recipe: widget.recipe)),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _confirmDelete(context, widget.recipe.id!);
                      },
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}