import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/entities/preparation_step.dart';
import 'package:recipe_app/services/preparation_step_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.preparationStep == null ? 'Add Step' : 'Edit Step'),
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
                controller: _stepOrderController,
                decoration: InputDecoration(
                  labelText: 'Step Order',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the Step Order';
                  } else if (int.parse(value) < 0) {
                    return 'The Step Order cannot be negative';
                  } else {
                    return null;
                  }
                }
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _instructionController,
                decoration: InputDecoration(
                  labelText: 'Instruction',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter the Instruction' : null,
              ),
              const SizedBox(height: 25),

              ElevatedButton(
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
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text(widget.preparationStep == null ? 'Create' : 'Update')
              ),
            ],
          ),
        ),
      ),
    );
  }
}