import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/food_menu/data/food_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('foods.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = join(dir.path, fileName);

      return await openDatabase(
        dbPath,
        version: 2,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
    } catch (e) {
      debugPrint('DB open error: $e');
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE foods (
          id INTEGER PRIMARY KEY,
          name TEXT,
          price REAL,
          image TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          food_id INTEGER UNIQUE
        )
      ''');
    } catch (e) {
      debugPrint('DB create error: $e');
      rethrow;
    }
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            food_id INTEGER UNIQUE
          )
        ''');

        final oldFavorites = await db.query('foods', columns: ['id']);
        final batch = db.batch();
        for (final row in oldFavorites) {
          final id = row['id'];
          if (id == null) continue;
          batch.insert(
            'favorites',
            {'food_id': id},
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
        await batch.commit(noResult: true);
      } catch (e) {
        debugPrint('DB upgrade v1->v2 warn: $e');
      }
    }
  }

  Future<int> insertFood(FoodModel food) async {
    try {
      final db = await instance.database;
      return await db.insert(
        'foods',
        food.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('insertFood error: $e');
      rethrow;
    }
  }

  Future<int> updateFood(FoodModel food) async {
    try {
      final db = await instance.database;
      return await db.update(
        'foods',
        food.toMap(),
        where: 'id = ?',
        whereArgs: [food.id],
      );
    } catch (e) {
      debugPrint('updateFood error: $e');
      rethrow;
    }
  }

  Future<List<FoodModel>> getFoods() async {
    try {
      final db = await instance.database;
      final result = await db.query('foods', orderBy: 'id ASC');
      return result.map((map) => FoodModel.fromMap(map)).toList();
    } catch (e) {
      debugPrint('getFoods error: $e');
      rethrow;
    }
  }

  Future<int> deleteFood(int id) async {
    try {
      final db = await instance.database;
      await db.delete('favorites', where: 'food_id = ?', whereArgs: [id]);
      return await db.delete('foods', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('deleteFood error: $e');
      rethrow;
    }
  }

  Future<int> deleteFoods() async {
    try {
      final db = await instance.database;
      await db.delete('favorites');
      return await db.delete('foods');
    } catch (e) {
      debugPrint('deleteFoods error: $e');
      rethrow;
    }
  }

  Future<int> addFavorite(int foodId) async {
    try {
      final db = await instance.database;
      return await db.insert(
        'favorites',
        {'food_id': foodId},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      debugPrint('addFavorite error: $e');
      rethrow;
    }
  }

  Future<int> removeFavorite(int foodId) async {
    try {
      final db = await instance.database;
      return await db.delete('favorites', where: 'food_id = ?', whereArgs: [foodId]);
    } catch (e) {
      debugPrint('removeFavorite error: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(int foodId) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'favorites',
        where: 'food_id = ?',
        whereArgs: [foodId],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      debugPrint('isFavorite error: $e');
      rethrow;
    }
  }

  Future<List<FoodModel>> getFavoriteFoods() async {
    try {
      final db = await instance.database;
      final result = await db.rawQuery('''
        SELECT f.id, f.name, f.price, f.image
        FROM foods f
        INNER JOIN favorites fav ON fav.food_id = f.id
        ORDER BY fav.id DESC
      ''');
      return result.map((map) => FoodModel.fromMap(map)).toList();
    } catch (e) {
      debugPrint('getFavoriteFoods error: $e');
      rethrow;
    }
  }

  Future<int> clearFavorites() async {
    try {
      final db = await instance.database;
      return await db.delete('favorites');
    } catch (e) {
      debugPrint('clearFavorites error: $e');
      rethrow;
    }
  }
}