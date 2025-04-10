import 'package:flutter/material.dart';
import 'package:recipe_app/entities/recipe_ingredient.dart';
import 'package:recipe_app/view/recipe_ingredient/recipe_ingredient_form_page.dart';

class RecipeIngredientListPage extends StatelessWidget {
  final List<RecipeIngredient> ingredients;
  final Function(int) onDelete;
  final Function onEdit;

  const RecipeIngredientListPage({super.key, required this.ingredients, required this.onDelete, required this.onEdit});
  
  void _confirmDelete(BuildContext context, int recipeIngredientId) {
    showDialog(
      context: context, 
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this Ingredient?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onDelete(recipeIngredientId);
                Navigator.pop(dialogContext);
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
    return Expanded(
      child: ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return ListTile(
            title: Text(ingredient.name, style: const TextStyle(fontSize: 14)),
            subtitle: Text(ingredient.quantity as String, style: const TextStyle(fontSize: 12)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => RecipeIngredientFormPage(recipeIngredient: ingredient, recipeId: ingredient.recipeId)),
                    ).then((_) {
                      onEdit();
                    });
                  }, 
                  icon: const Icon(Icons.edit, color: Color.fromARGB(255, 100, 100, 100))
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context, ingredient.id), 
                  icon: const Icon(Icons.delete, color: Color.fromARGB(255, 255, 24, 24))
                ),
              ],
            ),
          );
        },
      )
    );
  }
}