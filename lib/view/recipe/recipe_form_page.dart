import 'package:flutter/material.dart';
import 'package:recipe_app/entities/recipe.dart';
import 'package:recipe_app/services/random_service.dart';
import 'package:recipe_app/services/recipe_service.dart';
import 'package:provider/provider.dart';

class RecipeFormPage extends StatefulWidget {
  final Recipe? recipe;

  const RecipeFormPage({super.key, this.recipe});

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _preparationTimeMinutesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _nameController.text = widget.recipe!.name;
      _rateController.text = widget.recipe!.rate.toString();
      _preparationTimeMinutesController.text = widget.recipe!.preparationTimeMinutes.toString();
    }
  }

  void fillRandomValues() async {
    final randomService = Provider.of<RandomService>(context, listen: false);

    final randomString = await randomService.generateRandomString();
    final randomInt = randomService.generateRandomInteger();
    final randomDouble = randomService.generateRandomDouble();

    setState(() {
      _nameController.text = randomString.replaceAll("\"", "");
      _preparationTimeMinutesController.text = randomInt.toString();
      _rateController.text = randomDouble.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<RecipeService>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit Recipe')),
      
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Recipe Name'),
                validator: (value) => value!.isEmpty ? 'Enter a Recipe name' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _rateController,
                decoration: const InputDecoration(labelText: 'Recipe Rate'),
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a Recipe rate';
                  } else if (double.parse(value) < 0) {
                    return 'The Recipe rate cannot be negative';
                  } else {
                    return null;
                  }
                }
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _preparationTimeMinutesController,
                decoration: const InputDecoration(labelText: 'Recipe Preparation Time in Minutes'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a Recipe preparation time in minutes';
                  } else if (int.parse(value) < 0) {
                    return 'The Recipe preparation time in minutes cannot be negative';
                  } else {
                    return null;
                  }
                }
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  fillRandomValues();
                }, 
                child: Text('Generate Random Values'),
              ),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final id = widget.recipe?.id ?? 0;
                    final name = _nameController.text;
                    final rate = double.parse(_rateController.text);
                    final preparationTimeMinutes = int.parse(_preparationTimeMinutesController.text);

                    if (widget.recipe == null) {
                      service.create(Recipe(id: null, name: name, rate: rate, addedDate: DateTime.now(), preparationTimeMinutes: preparationTimeMinutes, ingredients: List.empty(), steps: List.empty()));
                    } else {
                      service.update(Recipe(id: id, name: name, rate: rate, addedDate: widget.recipe!.addedDate, preparationTimeMinutes: preparationTimeMinutes, ingredients: List.empty(), steps: List.empty()));
                    }

                    Navigator.pop(context);
                  }
                }, 
                child: Text(widget.recipe == null ? 'Create' : 'Update'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}