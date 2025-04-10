import 'package:flutter/material.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:recipe_app/view/recipe/recipe_details_page.dart';
import 'package:recipe_app/view/recipe/recipe_form_page.dart';
import 'package:provider/provider.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
    final service = Provider.of<RecipeService>(context);
    final filteredRecipes = service.findAll
        .where((recipe) => recipe.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),

            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Recipe',
                labelStyle: TextStyle(color: Colors.deepPurple),
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.deepPurple.withValues(alpha: 0.6)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final item = filteredRecipes[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Preparation time: ${item.preparationTimeMinutes} minutes | Rate: ${item.rate}'),

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
                            MaterialPageRoute(builder: (context) => RecipeFormPage(recipe: item)),
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, item.id),
                      ),

                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RecipeFormPage()),
          );
        },
      ),
    );
  }
}
