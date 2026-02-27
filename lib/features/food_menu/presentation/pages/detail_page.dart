import 'package:flutter/material.dart';
import '../../data/food_model.dart';
import '../../../../core/database/database_helper.dart';

class FoodExtra {
  final String descripcion;
  final List<String> ingredientes;

  const FoodExtra({
    required this.descripcion,
    required this.ingredientes,
  });
}

class DetailPage extends StatefulWidget {
  //Se convierte en StatefulWidget porque la estrella cambia dinamicamente
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  //Esta variable indica si el plantillo es favorito o no
  bool isFavorite = false;
  late FoodModel food;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    food = ModalRoute.of(context)!.settings.arguments as FoodModel;
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final fav = await DatabaseHelper.instance.isFavorite(food.id);
    setState(() => isFavorite = fav);
  }

  static const Map<int, FoodExtra> _extras = {
    1: FoodExtra(
      descripcion:
      'Una hamburguesa jugosa con carne 100% res, pan artesanal y vegetales frescos.',
      ingredientes: [
        'Pan artesanal',
        'Carne de res',
        'Queso cheddar',
        'Lechuga',
        'Tomate',
        'Salsa especial',
      ],
    ),
    2: FoodExtra(
      descripcion:
      'Pizza al horno con pepperoni, queso mozzarella y salsa de tomate casera.',
      ingredientes: [
        'Masa artesanal',
        'Salsa de tomate',
        'Mozzarella',
        'Pepperoni',
        'Orégano',
      ],
    ),
    3: FoodExtra(
      descripcion:
      'Tacos tradicionales con pastor, piña y cilantro, servidos en tortilla de maíz.',
      ingredientes: [
        'Tortilla de maíz',
        'Carne al pastor',
        'Piña',
        'Cilantro',
        'Cebolla',
        'Salsa',
      ],
    ),
    4: FoodExtra(
      descripcion:
      'Ensalada clásica con pollo, croutones y aderezo César cremoso.',
      ingredientes: [
        'Lechuga romana',
        'Pollo',
        'Croutones',
        'Queso parmesano',
        'Aderezo César',
      ],
    ),
    5: FoodExtra(
      descripcion:
      'Roll de sushi fresco con arroz sazonado, alga nori y relleno del día.',
      ingredientes: [
        'Arroz para sushi',
        'Alga nori',
        'Pepino',
        'Aguacate',
        'Proteína (salmón/atún)',
        'Soya',
      ],
    ),
    6: FoodExtra(
      descripcion:
      'Pasta cremosa con salsa Alfredo, queso parmesano y toque de ajo.',
      ingredientes: [
        'Pasta',
        'Crema',
        'Mantequilla',
        'Ajo',
        'Queso parmesano',
        'Perejil',
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    final extra = _extras[food.id] ??
        const FoodExtra(
          descripcion: 'Sin descripción disponible.',
          ingredientes: ['Sin ingredientes registrados.'],
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
            onPressed: () async {
              if (isFavorite) {
                await DatabaseHelper.instance.deleteFood(food.id);
              } else {
                await DatabaseHelper.instance.insertFood(food);
              }

              setState(() => isFavorite = !isFavorite);

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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'food-image-${food.id}',
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  food.imagen,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image_outlined, size: 56),
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Text(
                food.nombre,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '\$${food.precio.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                extra.descripcion,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Ingredientes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: extra.ingredientes
                    .map(
                      (i) => Chip(
                    label: Text(i),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Añadir al carrito'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Añadido al carrito: ${food.nombre}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
