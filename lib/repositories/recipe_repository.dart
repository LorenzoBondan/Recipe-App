import 'package:sqflite/sqflite.dart';
import 'package:recipe_app/entities/Recipe.dart';
import 'package:recipe_app/repositories/database_helper.dart';

class RecipeRepository {
  Future<Database> get _db async => await DatabaseHelper().database;

  String tableName = 'recipes';

  Future<List<Recipe>> findAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) => Recipe.fromMap(maps[i]));
  }

  Future<Recipe?> findById(int id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Recipe.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> create(Recipe obj) async {
    final db = await _db;
    return await db.insert(tableName, obj.toMap());
  }

  Future<int> update(Recipe obj) async {
    final db = await _db;
    return await db.update(
      tableName,
      obj.toMap(),
      where: 'id = ?',
      whereArgs: [obj.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}