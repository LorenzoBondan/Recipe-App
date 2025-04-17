import 'dart:convert';

class PreparationStep {
  final int? id;
  final int stepOrder;
  final String instruction;
  final int recipeId;

  PreparationStep({required this.id, required this.stepOrder, required this.instruction, required this.recipeId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'step_order': stepOrder,
      'instruction': instruction,
      'recipe_id': recipeId,
    };
  }

  factory PreparationStep.fromMap(Map<String, dynamic> map) {
    return PreparationStep(
      id: map['id'] as int,
      stepOrder: map['step_order'] as int,
      instruction: map['instruction'] as String,
      recipeId: map['recipe_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PreparationStep.fromJson(String source) => PreparationStep.fromMap(json.decode(source) as Map<String, dynamic>);
}
