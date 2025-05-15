import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static const String dbName = 'recipe_app_oficial.db';

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, dbName);

    print("##### Caminho do Banco: $dbPath");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
        await _insertInitialData(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _upgradeDatabase(db, oldVersion, newVersion);
      },
      onDowngrade: (db, oldVersion, newVersion) async {
        await _resetDatabase(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        rate REAL,
        added_date TEXT NOT NULL,
        preparation_time_minutes INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE recipe_ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity REAL NOT NULL,
        recipe_id INTEGER NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE preparation_steps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        step_order INTEGER NOT NULL,
        instruction TEXT NOT NULL,
        recipe_id INTEGER NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _insertInitialData(Database db) async {
    int recipeId = await db.insert("recipes", {
        "name": "Chocolate Cake",
        "rate": 4.5,
        "added_date": DateTime.now().toIso8601String(),
        "preparation_time_minutes": 60
      });

      await db.insert("recipe_ingredients", {
        "name": "Flour",
        "quantity": 2.5,
        "recipe_id": recipeId
      });

      await db.insert("recipe_ingredients", {
        "name": "Sugar",
        "quantity": 1.5,
        "recipe_id": recipeId
      });

      await db.insert("recipe_ingredients", {
        "name": "Cocoa Powder",
        "quantity": 0.75,
        "recipe_id": recipeId
      });

      await db.insert("preparation_steps", {
        "step_order": 1,
        "instruction": "Preheat the oven to 180°C.",
        "recipe_id": recipeId
      });

      await db.insert("preparation_steps", {
        "step_order": 2,
        "instruction": "Mix flour, sugar, and cocoa powder.",
        "recipe_id": recipeId
      });

      await db.insert("preparation_steps", {
        "step_order": 3,
        "instruction": "Pour the batter into a baking pan and bake for 35 minutes.",
        "recipe_id": recipeId
      });
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await _resetDatabase(db);
    }
  }

  Future<void> _resetDatabase(Database db) async {
    await db.execute("DROP TABLE IF EXISTS recipes");
    await db.execute("DROP TABLE IF EXISTS recipe_ingredients");
    await db.execute("DROP TABLE IF EXISTS preparation_steps");
    await _createTables(db);
    await _insertInitialData(db);
  }
}