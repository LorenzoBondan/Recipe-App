import 'package:sqflite/sqflite.dart';
import 'package:recipe_app/entities/preparation_step.dart';
import 'package:recipe_app/repositories/database_helper.dart';

class PreparationStepRepository {
  Future<Database> get _db async => DatabaseHelper().database;

  String tableName = 'preparation_steps';

  Future<List<PreparationStep>> findAll() async {
    final db = await _db;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) => PreparationStep.fromMap(maps[i]));
  }

  Future<List<PreparationStep>> findByRecipeId(int recipeId) async {
    final db = await _db;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName, 
      where: 'recipe_id = ?', 
      whereArgs: [recipeId]
    );
    
    return List.generate(maps.length, (i) => PreparationStep.fromMap(maps[i]));
  }

  Future<PreparationStep?> findById(int id) async {
    final db = await _db;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName, 
      where: 'id = ?', 
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return PreparationStep.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> create(PreparationStep obj) async {
    final db = await _db;
    
    return await db.insert(tableName, obj.toMap());
  }

  Future<int> update(PreparationStep obj) async {
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