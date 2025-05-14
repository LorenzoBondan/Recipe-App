import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/entities/preparation_step.dart';
import 'package:recipe_app/services/preparation_step_service.dart';
import 'package:recipe_app/services/random_service.dart';

class PreparationStepFormPage extends StatefulWidget {
  final PreparationStep? preparationStep;
  final int? recipeId;

  const PreparationStepFormPage({super.key, this.preparationStep, this.recipeId});

  @override
  State<PreparationStepFormPage> createState() => _PreparationStepFormPageState();
}

class _PreparationStepFormPageState extends State<PreparationStepFormPage> {
  late PreparationStepService service;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _stepOrderController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    service = Provider.of<PreparationStepService>(context, listen: false);
    
    if (widget.preparationStep != null) {
      _stepOrderController.text = widget.preparationStep!.stepOrder.toString();
      _instructionController.text = widget.preparationStep!.instruction;
    }
  }

  void fillRandomValues() async {
    final randomService = Provider.of<RandomService>(context, listen: false);

    final randomString = await randomService.generateRandomString();
    final randomInt = randomService.generateRandomInteger();

    setState(() {
      _stepOrderController.text = randomInt.toString();
      _instructionController.text = randomString.replaceAll("\"", "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.preparationStep == null ? 'Add Step' : 'Edit Step', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
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
                controller: _stepOrderController,
                cursorErrorColor: Colors.grey[800],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Step Order',
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
                    return 'Enter the Step Order';
                  } else if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  } else if (int.parse(value) < 0) {
                    return 'The Step Order cannot be negative';
                  } else {
                    return null;
                  }
                }
              ),

              const SizedBox(height: 25),
              TextFormField(
                controller: _instructionController,
                cursorErrorColor: Colors.grey[800],
                decoration: InputDecoration(
                  labelText: 'Instruction',
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
                validator: (value) => value!.isEmpty ? 'Enter the Instruction' : null,
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
                          final id = widget.preparationStep?.id ?? 0;
                          final stepOrder = int.parse(_stepOrderController.text);
                          final instruction = _instructionController.text;

                          if (widget.preparationStep == null) {
                            service.create(PreparationStep(id: null, recipeId: widget.recipeId!, stepOrder: stepOrder, instruction: instruction));
                          } else {
                            service.update(PreparationStep(id: id, recipeId: widget.recipeId!, stepOrder: stepOrder, instruction: instruction));
                          }

                          Navigator.pop(context);
                        }
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(widget.preparationStep == null ? 'Create' : 'Update')
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