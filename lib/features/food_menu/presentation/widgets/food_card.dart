import 'package:flutter/material.dart';

import '../../data/datasources/favorites_local_datasource.dart';
import '../../data/food_model.dart';

class FoodCard extends StatefulWidget {
  final FoodModel food;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteChanged;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    this.onFavoriteChanged,
  });

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  final FavoritesLocalDatasource _favoritesDatasource = FavoritesLocalDatasource();

  bool _isFavorite = false;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  @override
  void didUpdateWidget(covariant FoodCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.food.id != widget.food.id) {
      _loadFavorite();
    }
  }

  Future<void> _loadFavorite() async {
    try {
      final fav = await _favoritesDatasource.isFavorite(widget.food.id);
      if (!mounted) return;
      setState(() => _isFavorite = fav);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isFavorite = false);
    }
  }

  Future<void> _toggleFavorite() async {
    if (_processing) return;

    setState(() => _processing = true);

    try {
      if (_isFavorite) {
        await _favoritesDatasource.removeFavorite(widget.food.id);
      } else {
        await _favoritesDatasource.addFavorite(widget.food);
      }

      if (!mounted) return;
      setState(() => _isFavorite = !_isFavorite);

      widget.onFavoriteChanged?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite ? 'Añadido a favoritos' : 'Eliminado de favoritos'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo actualizar favorito. Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'food-image-${widget.food.id}',
                child: Image.network(
                  widget.food.imagen,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image_outlined, size: 44),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.food.precio.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _toggleFavorite,
                        child: _processing
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Icon(
                          _isFavorite ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}