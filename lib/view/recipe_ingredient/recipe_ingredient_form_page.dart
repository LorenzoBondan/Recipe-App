import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/entities/recipe_ingredient.dart';
import 'package:recipe_app/services/recipe_ingredient_service.dart';

class RecipeIngredientFormPage extends StatefulWidget {
  final RecipeIngredient? recipeIngredient;
  final int? recipeId;

  const RecipeIngredientFormPage({super.key, this.recipeIngredient, this.recipeId});

  @override
  State<RecipeIngredientFormPage> createState() => _RecipeIngredientFormPageState();
}

class _RecipeIngredientFormPageState extends State<RecipeIngredientFormPage> {
  late RecipeIngredientService service;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    service = Provider.of<RecipeIngredientService>(context, listen: false);
    
    if (widget.recipeIngredient != null) {
      _nameController.text = widget.recipeIngredient!.name;
      _quantityController.text = widget.recipeIngredient!.quantity.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeIngredient == null ? 'Add Ingredient' : 'Edit Ingredient', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                cursorErrorColor: Colors.grey[800],
                decoration: InputDecoration(
                  labelText: 'Ingredient Name',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  floatingLabelStyle: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[500] ?? const Color.fromARGB(255, 158, 158, 158)),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700] ?? const Color.fromARGB(255, 97, 97, 97)),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Enter the name of the Ingredient' : null,
              ),

              const SizedBox(height: 25),
              TextFormField(
                controller: _quantityController,
                cursorErrorColor: Colors.grey[800],
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                decoration: InputDecoration(
                  labelText: 'Ingredient Quantity',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  floatingLabelStyle: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[500] ?? const Color.fromARGB(255, 158, 158, 158)),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700] ?? const Color.fromARGB(255, 97, 97, 97)),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the quantity of the Ingredient';
                  } else if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  } else if (double.parse(value) < 0) {
                    return 'The quantity of the Ingredient cannot be negative';
                  } else {
                    return null;
                  }
                }
              ),

              const SizedBox(height: 30),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final id = widget.recipeIngredient?.id ?? 0;
                          final name = _nameController.text;
                          final quantity = double.parse(_quantityController.text);

                          if (widget.recipeIngredient == null) {
                            service.create(RecipeIngredient(id: null, recipeId: widget.recipeId!, name: name, quantity: quantity));
                          } else {
                            service.update(RecipeIngredient(id: id, recipeId: widget.recipeId!, name: name, quantity: quantity));
                          }

                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(widget.recipeIngredient == null ? 'Create' : 'Update'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}