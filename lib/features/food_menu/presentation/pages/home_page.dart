import 'package:flutter/material.dart';

import '../../data/datasources/food_local_datasource.dart';
import '../../data/food_model.dart';
import '../widgets/food_card.dart';
import 'food_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FoodLocalDatasource _foodDatasource = FoodLocalDatasource();

  List<FoodModel> _foods = [];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await _foodDatasource.seedFoodsIfNeeded();
      final foods = await _foodDatasource.getFoods();
      if (!mounted) return;
      setState(() => _foods = foods);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'No se pudo cargar el catálogo.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _createFood() async {
    final created = await Navigator.push<FoodModel>(
      context,
      MaterialPageRoute(builder: (_) => const FoodFormPage()),
    );
    if (created == null) return;

    try {
      await _foodDatasource.insertFood(created);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comida agregada (insertFood)')),
      );
      _loadFoods();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error agregando: $e')),
      );
    }
  }

  Future<void> _deleteAllFoods() async {
    try {
      await _foodDatasource.deleteFoods();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menú eliminado (deleteFoods)')),
      );
      _loadFoods();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error eliminando todo: $e')),
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
        const SnackBar(content: Text('Comida actualizada (updateFood)')),
      );
      _loadFoods();
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
        const SnackBar(content: Text('Comida eliminada (deleteFood)')),
      );
      _loadFoods();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error eliminando: $e')),
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
                  onPressed: _loadFoods,
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
        onRefresh: _loadFoods,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _createFood,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _deleteAllFoods,
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Eliminar todo'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: _foods.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final food = _foods[index];

                    return GestureDetector(
                      onLongPress: () async {
                        final action = await showModalBottomSheet<String>(
                          context: context,
                          builder: (_) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Editar'),
                                  onTap: () => Navigator.pop(context, 'edit'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Eliminar'),
                                  onTap: () => Navigator.pop(context, 'delete'),
                                ),
                              ],
                            ),
                          ),
                        );

                        if (action == 'edit') await _editFood(food);
                        if (action == 'delete') await _deleteFood(food);
                      },
                      child: FoodCard(
                        key: ValueKey(food.id),
                        food: food,
                        onTap: () async {
                          await Navigator.pushNamed(context, '/detail', arguments: food);
                          if (mounted) setState(() {});
                        },
                        onFavoriteChanged: () {
                          if (mounted) setState(() {});
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