import 'package:flutter/material.dart';
import '../../data/food_model.dart';
import '../../../../core/database/database_helper.dart';
import '../widgets/food_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  //Lista donde se guardan los favoritos obtenidos de SQLite
  List<FoodModel> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Cargar favoritos al abrir la pantalla
  }

  // Cargar favoritos desde SQLite
  Future<void> _loadFavorites() async {
    final data = await DatabaseHelper.instance.getFoods();
    //Actualizamos la lista en pantalla
    setState(() {
      _favorites = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Si no hay favoritos, mostramos un mensaje
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _favorites.isEmpty
            ? const Center(
          child: Text(
            'No tienes favoritos aún.',
            style: TextStyle(fontSize: 18),
          ),
        )
        //Si hay favoritos, los mostraremos en un GridView
            : GridView.builder(
          itemCount: _favorites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final food = _favorites[index];
            return FoodCard(
              food: food,
              //Al tocar un favorito, vamos a DetailPage
              onTap: () async {
                // Ir al detalle
                await Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: food,
                );
                // Recargar favoritos al volver, si se elimina uno
                _loadFavorites();
              },
              onFavoriteChanged: () {
                _loadFavorites();
              },
            );
          },
        ),
      ),
    );
  }
}