import 'dart:convert';

class RecipeIngredient {
  final int? id;
  final String name;
  final double quantity;
  final int recipeId;

  RecipeIngredient({required this.id, required this.name, required this.quantity, required this.recipeId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quantity': quantity,
      'recipe_id': recipeId,
    };
  }

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeIngredient(
      id: map['id'] as int,
      name: map['name'] as String,
      quantity: map['quantity'] as double,
      recipeId: map['recipe_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeIngredient.fromJson(String source) => RecipeIngredient.fromMap(json.decode(source) as Map<String, dynamic>);
}
