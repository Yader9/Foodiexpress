import 'package:flutter/material.dart';
import 'package:foodiexpress/core/database/database_helper.dart';
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
  bool isFavorite = false;

  @override
  void didUpdateWidget(covariant FoodCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.food.id != widget.food.id) {
      _loadFavorite();
    } else {
      _loadFavorite(); //fuerza recarga aunque sea el mismo food
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final fav = await DatabaseHelper.instance.isFavorite(widget.food.id);
    setState(() => isFavorite = fav);
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.food.precio.toStringAsFixed(2)}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (isFavorite) {
                            await DatabaseHelper.instance.deleteFood(
                                widget.food.id);
                          }
                          else {
                            await DatabaseHelper.instance.insertFood(
                                widget.food);
                          }

                          setState(() => isFavorite = !isFavorite);

                          //Notificar al padre
                          if (widget.onFavoriteChanged != null) {
                            widget.onFavoriteChanged!();
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Añadido a favoritos'
                                    : 'Eliminado de favoritos',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );

                        },
                        child: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
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