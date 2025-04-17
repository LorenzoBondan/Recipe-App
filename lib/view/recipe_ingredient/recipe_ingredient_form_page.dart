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
        title: Text(widget.recipeIngredient == null ? 'Add Ingredient' : 'Edit Ingredient'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter the name of the Ingredient' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the quantity of the Ingredient';
                  } else if (double.parse(value) < 0) {
                    return 'The quantity cannot be negative';
                  } else {
                    return null;
                  }
                }
              ),
              const SizedBox(height: 10),

              ElevatedButton(
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
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text(widget.recipeIngredient == null ? 'Create' : 'Update')
              ),
            ],
          ),
        ),
      ),
    );
  }
}