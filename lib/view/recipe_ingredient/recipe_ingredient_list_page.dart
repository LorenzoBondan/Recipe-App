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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Confirm Deletion',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this Ingredient?',
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
                onDelete(recipeIngredientId);
                Navigator.pop(dialogContext);
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
    return Expanded(
      child: ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return ListTile(
            title: Text(
              ingredient.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(fontSize: 14, color: Colors.grey[800], fontWeight: FontWeight.bold)
            ),
            subtitle: Text('Quantity: ${ingredient.quantity.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
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
                  icon: Icon(Icons.edit)
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context, ingredient.id!), 
                  icon: const Icon(Icons.delete, color: Colors.red)
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => RecipeIngredientFormPage(recipeIngredient: ingredient, recipeId: ingredient.recipeId)),
              ).then((_) {
                onEdit();
              });
            },
          );
        },
      )
    );
  }
}