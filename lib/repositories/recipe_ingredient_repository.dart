import 'package:sqflite/sqflite.dart';
import 'package:recipe_app/entities/recipe_ingredient.dart';
import 'package:recipe_app/repositories/database_helper.dart';

class RecipeIngredientRepository {
  Future<Database> get _db async => DatabaseHelper().database;

  String tableName = 'recipe_ingredients';

  Future<List<RecipeIngredient>> findAll() async {
    final db = await _db;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) => RecipeIngredient.fromMap(maps[i]));
  }

  Future<List<RecipeIngredient>> findByRecipeId(int recipeId) async {
    final db = await _db;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName, 
      where: 'recipe_id = ?', 
      whereArgs: [recipeId]
    );
    
    return List.generate(maps.length, (i) => RecipeIngredient.fromMap(maps[i]));
  }

  Future<RecipeIngredient?> findById(int id) async {
    final db = await _db;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName, 
      where: 'id = ?', 
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return RecipeIngredient.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> create(RecipeIngredient obj) async {
    final db = await _db;
    
    return await db.insert(tableName, obj.toMap());
  }

  Future<int> update(RecipeIngredient obj) async {
    final db = await _db;

    return await db.update(
      tableName, 
      obj.toMap(),
      where: 'id = ?',
      whereArgs: [obj.id]
    );
  }

  Future<int> delete(int id) async {
    final db = await _db;

    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}