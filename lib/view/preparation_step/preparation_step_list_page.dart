import 'package:flutter/material.dart';
import 'package:recipe_app/entities/preparation_step.dart';
import 'package:recipe_app/view/preparation_step/preparation_step_form_page.dart';

class PreparationStepListPage extends StatelessWidget {
  final List<PreparationStep> steps;
  final Function(int) onDelete;
  final Function onEdit;

  const PreparationStepListPage({super.key, required this.steps, required this.onDelete, required this.onEdit});
  
  void _confirmDelete(BuildContext context, int preparationStepId) {
    showDialog(
      context: context, 
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this Step?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onDelete(preparationStepId);
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
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = steps[index];
          return ListTile(
            title: Text(step.stepOrder as String, style: const TextStyle(fontSize: 14)),
            subtitle: Text(step.instruction, style: const TextStyle(fontSize: 12)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => PreparationStepFormPage(preparationStep: step, recipeId: step.recipeId)),
                    ).then((_) {
                      onEdit();
                    });
                  }, 
                  icon: const Icon(Icons.edit, color: Color.fromARGB(255, 100, 100, 100))
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context, step.id), 
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