import 'package:flutter/material.dart';

import '../../data/datasources/favorites_local_datasource.dart';
import '../../data/datasources/food_local_datasource.dart';
import '../../data/food_model.dart';
import '../widgets/food_card.dart';
import 'food_form_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesLocalDatasource _favoritesDatasource = FavoritesLocalDatasource();
  final FoodLocalDatasource _foodDatasource = FoodLocalDatasource();

  List<FoodModel> _favorites = [];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final data = await _favoritesDatasource.getFavorites();
      if (!mounted) return;
      setState(() => _favorites = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'No se pudieron cargar tus favoritos.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _addAndFavorite() async {
    final created = await Navigator.push<FoodModel>(
      context,
      MaterialPageRoute(builder: (_) => const FoodFormPage()),
    );
    if (created == null) return;

    try {
      await _foodDatasource.insertFood(created);
      await _favoritesDatasource.addFavorite(created);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agregado y marcado como favorito')),
      );
      _loadFavorites();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _clearFavorites() async {
    try {
      await _favoritesDatasource.clearFavorites();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Favoritos vaciados')),
      );
      _loadFavorites();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error vaciando favoritos: $e')),
      );
    }
  }

  Future<void> _editFood(FoodModel food) async {
    final updated = await Navigator.push<FoodModel>(
      context,
      MaterialPageRoute(builder: (_) => FoodFormPage(initial: food)),
    );
    if (updated == null) return;

    try {
      await _foodDatasource.updateFood(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comida actualizada')),
      );
      _loadFavorites();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error actualizando: $e')),
      );
    }
  }

  Future<void> _deleteFood(FoodModel food) async {
    try {
      await _foodDatasource.deleteFood(food.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comida eliminada (y favorito limpiado)')),
      );
      _loadFavorites();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error eliminando: $e')),
      );
    }
  }

  Future<void> _removeFavorite(FoodModel food) async {
    try {
      await _favoritesDatasource.removeFavorite(food.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Eliminado de favoritos')),
      );
      _loadFavorites();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error quitando favorito: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _loadFavorites,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadFavorites,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _addAndFavorite,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar y marcar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _clearFavorites,
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Vaciar favs'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _favorites.isEmpty
                    ? ListView(
                  children: const [
                    SizedBox(height: 180),
                    Center(
                      child: Text('No tienes favoritos aún.', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                )
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

                    return GestureDetector(
                      onLongPress: () async {
                        final action = await showModalBottomSheet<String>(
                          context: context,
                          builder: (_) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.star_border),
                                  title: const Text('Quitar de favoritos'),
                                  onTap: () => Navigator.pop(context, 'unfav'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Editar comida'),
                                  onTap: () => Navigator.pop(context, 'edit'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Eliminar comida'),
                                  onTap: () => Navigator.pop(context, 'delete'),
                                ),
                              ],
                            ),
                          ),
                        );

                        if (action == 'unfav') await _removeFavorite(food);
                        if (action == 'edit') await _editFood(food);
                        if (action == 'delete') await _deleteFood(food);
                      },
                      child: FoodCard(
                        key: ValueKey('fav-${food.id}'),
                        food: food,
                        onTap: () async {
                          await Navigator.pushNamed(context, '/detail', arguments: food);
                          _loadFavorites();
                        },
                        onFavoriteChanged: () {
                          _loadFavorites();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}