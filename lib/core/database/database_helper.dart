import 'package:foodiexpress/features/food_menu/data/food_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Devulve la base de datos abierta. Si no existe la crea
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('foods.db');
    return _database!;
  }

  // Abrir la base de datos
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Crear tablas 'foods' con sus columnas
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE foods (
        id INTEGER PRIMARY KEY,
        name TEXT,
        price REAL,
        image TEXT
      )
    ''');
  }
  //Insertar un platillo en 'foods', lo marca como favorito
  Future<int> insertFood(FoodModel food) async {
    final db = await instance.database;

    return await db.insert(
      'foods',
      food.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  //Tiene los platos guardados como favoritos
  Future<List<FoodModel>> getFoods() async {
    final db = await instance.database;

    final result = await db.query('foods');

    return result.map((map) => FoodModel.fromMap(map)).toList();
  }

  //Eliminar los platos como favorito
  Future<int> deleteFood(int id) async {
    final db = await instance.database;

    return await db.delete(
      'foods',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Verificar si un platillo ya esta guardado como favorito
  Future<bool> isFavorite(int id) async {
    final db = await instance.database;

    final result = await db.query(
      'foods',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty; //Si hay resultados, es favorito
  }
}