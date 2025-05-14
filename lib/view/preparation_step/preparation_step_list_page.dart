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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Confirm Deletion',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this Step?',
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
                onDelete(preparationStepId);
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
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = steps[index];
          return ListTile(
            title: Text('Step ${step.stepOrder}', style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.bold)),
            subtitle: Text(
              'Instruction: ${step.instruction}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(fontSize: 12),
            ),
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
                  icon: const Icon(Icons.edit)
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context, step.id!), 
                  icon: Icon(Icons.delete, color: Colors.red)
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => PreparationStepFormPage(preparationStep: step, recipeId: step.recipeId)),
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