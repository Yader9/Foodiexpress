import '../../../../core/database/database_helper.dart';
import '../food_model.dart';

class FavoritesLocalDatasource {
  final DatabaseHelper _dbHelper;

  FavoritesLocalDatasource({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<void> addFavorite(FoodModel food) async {
    try {
      await _dbHelper.insertFood(food);
      await _dbHelper.addFavorite(food.id);
    } catch (e) {
      throw Exception('Error al añadir a favoritos: $e');
    }
  }

  Future<void> removeFavorite(int foodId) async {
    try {
      await _dbHelper.removeFavorite(foodId);
    } catch (e) {
      throw Exception('Error al eliminar de favoritos: $e');
    }
  }

  Future<bool> isFavorite(int foodId) async {
    try {
      return await _dbHelper.isFavorite(foodId);
    } catch (e) {
      throw Exception('Error al verificar favorito: $e');
    }
  }

  Future<List<FoodModel>> getFavorites() async {
    try {
      return await _dbHelper.getFavoriteFoods();
    } catch (e) {
      throw Exception('Error al obtener favoritos: $e');
    }
  }

  Future<void> clearFavorites() async {
    try {
      await _dbHelper.clearFavorites();
    } catch (e) {
      throw Exception('Error al vaciar favoritos: $e');
    }
  }
}