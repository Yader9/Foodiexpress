import '../../../../core/database/database_helper.dart';
import '../food_model.dart';

class FoodLocalDatasource {
  final DatabaseHelper _dbHelper;

  FoodLocalDatasource({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  static const List<FoodModel> seedFoods = [
    FoodModel(
      id: 1,
      nombre: 'Burger Clásica',
      precio: 6.99,
      imagen:
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&fm=jpg&q=60&w=1600',
    ),
    FoodModel(
      id: 2,
      nombre: 'Pizza Pepperoni',
      precio: 10.50,
      imagen:
      'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?auto=format&fit=crop&fm=jpg&q=60&w=1600',
    ),
    FoodModel(
      id: 3,
      nombre: 'Tacos al Pastor',
      precio: 8.25,
      imagen:
      'https://images.unsplash.com/photo-1683062332605-4e1209d75346?auto=format&fit=crop&fm=jpg&q=60&w=1600',
    ),
    FoodModel(
      id: 4,
      nombre: 'Ensalada César',
      precio: 7.40,
      imagen:
      'https://images.unsplash.com/photo-1746211108786-ca20c8f80ecd?auto=format&fit=crop&fm=jpg&q=60&w=1600',
    ),
    FoodModel(
      id: 5,
      nombre: 'Sushi Roll',
      precio: 12.99,
      imagen:
      'https://images.unsplash.com/photo-1713453018516-b08018818c0c?auto=format&fit=crop&fm=jpg&q=60&w=1600',
    ),
    FoodModel(
      id: 6,
      nombre: 'Pasta Alfredo',
      precio: 11.30,
      imagen:
      'https://images.unsplash.com/photo-1578413079255-7b8a64409ced?auto=format&fit=crop&fm=jpg&q=60&w=1600',
    ),
    FoodModel(
      id: 7,
      nombre: 'Burrito de Pollo',
      precio: 9.10,
      imagen:
      'https://images.unsplash.com/photo-1731090389603-d63060ee08a6?auto=format&fit=crop&fm=jpg&q=60&w=1600',
    ),
    FoodModel(
      id: 8,
      nombre: 'Ramen Tonkotsu',
      precio: 13.75,
      imagen:
      'https://images.unsplash.com/photo-1535007813616-79dc02ba4021?auto=format&fit=crop&fm=jpg&q=60&w=1600',
    ),
    FoodModel(
      id: 9,
      nombre: 'Pollo Frito',
      precio: 9.95,
      imagen:
      'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?auto=format&fit=crop&fm=jpg&q=60&w=1600',
    ),
    FoodModel(
      id: 10,
      nombre: 'Brownie con Helado',
      precio: 6.50,
      imagen:
      'https://images.unsplash.com/photo-1639744093694-4225490cf1d1?auto=format&fit=crop&fm=jpg&q=60&w=1600',
    ),
  ];

  Future<void> seedFoodsIfNeeded() async {
    try {
      for (final food in seedFoods) {
        await _dbHelper.insertFood(food);
      }
    } catch (e) {
      throw Exception('Error al cargar/sembrar el catálogo: $e');
    }
  }

  Future<int> insertFood(FoodModel food) async {
    try {
      return await _dbHelper.insertFood(food);
    } catch (e) {
      throw Exception('Error insertando platillo: $e');
    }
  }

  Future<int> updateFood(FoodModel food) async {
    try {
      return await _dbHelper.updateFood(food);
    } catch (e) {
      throw Exception('Error actualizando platillo: $e');
    }
  }

  Future<List<FoodModel>> getFoods() async {
    try {
      return await _dbHelper.getFoods();
    } catch (e) {
      throw Exception('Error obteniendo platillos: $e');
    }
  }

  Future<int> deleteFood(int id) async {
    try {
      return await _dbHelper.deleteFood(id);
    } catch (e) {
      throw Exception('Error eliminando platillo: $e');
    }
  }

  Future<int> deleteFoods() async {
    try {
      return await _dbHelper.deleteFoods();
    } catch (e) {
      throw Exception('Error eliminando todos los platillos: $e');
    }
  }
}