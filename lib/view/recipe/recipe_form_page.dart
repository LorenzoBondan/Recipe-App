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
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit Recipe', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                cursorErrorColor: Colors.grey[800],
                decoration: InputDecoration(
                  labelText: 'Recipe Name',
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
                validator: (value) => value!.isEmpty ? 'Enter a Recipe name' : null,
              ),

              const SizedBox(height: 25),
              TextFormField(
                controller: _rateController,
                cursorErrorColor: Colors.grey[800],
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                decoration: InputDecoration(
                  labelText: 'Recipe Rate',
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
                    return 'Enter a Recipe rate';
                  } else if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  } else if (double.parse(value) < 0) {
                    return 'The Recipe rate cannot be negative';
                  } else {
                    return null;
                  }
                }
              ),

              const SizedBox(height: 25),
              TextFormField(
                controller: _preparationTimeMinutesController,
                cursorErrorColor: Colors.grey[800],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Recipe Preparation Time in Minutes',
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
                    return 'Enter a Recipe preparation time in minutes';
                  } else if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  } else if (int.parse(value) < 0) {
                    return 'The Recipe preparation time in minutes cannot be negative';
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
                        fillRandomValues();
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(widget.recipe == null ? 'Create' : 'Update'),
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