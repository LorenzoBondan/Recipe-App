import 'package:flutter/material.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/view/recipe/recipe_details_page.dart';
import 'package:recipe_app/view/recipe/recipe_form_page.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<RecipeService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: service.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: service.findAll.length,
              itemBuilder: (context, index) {
                final item = service.findAll[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailsPage(recipe: item),
                            ),
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeFormPage(recipe: item),
                            ),
                          );
                        },
                      ),
                      
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await service.delete(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Recipe deleted')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RecipeFormPage(),
            ),
          );
        },
      ),
    );
  }
}
