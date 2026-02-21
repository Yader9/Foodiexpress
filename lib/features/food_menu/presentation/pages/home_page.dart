import 'package:flutter/material.dart';
import '../../data/food_model.dart';
import '../widgets/food_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Catálogo "mock" (sin backend) para el laboratorio.
  static const List<FoodModel> _foods = [
    FoodModel(
      id: 1,
      nombre: 'Burger Clásica',
      precio: 6.99,
      imagen:
          'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=1200&q=80',
    ),
    FoodModel(
      id: 2,
      nombre: 'Pizza Pepperoni',
      precio: 10.50,
      imagen:
          'https://images.unsplash.com/photo-1548365328-9f547fb0952e?auto=format&fit=crop&w=1200&q=80',
    ),
    FoodModel(
      id: 3,
      nombre: 'Tacos al Pastor',
      precio: 8.25,
      imagen:
          'https://images.unsplash.com/photo-1615870216519-2f9fa575fa5c?auto=format&fit=crop&w=1200&q=80',
    ),
    FoodModel(
      id: 4,
      nombre: 'Ensalada César',
      precio: 7.40,
      imagen:
          'https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?auto=format&fit=crop&w=1200&q=80',
    ),
    FoodModel(
      id: 5,
      nombre: 'Sushi Roll',
      precio: 12.99,
      imagen:
          'https://images.unsplash.com/photo-1553621042-f6e147245754?auto=format&fit=crop&w=1200&q=80',
    ),
    FoodModel(
      id: 6,
      nombre: 'Pasta Alfredo',
      precio: 11.30,
      imagen:
          'https://images.unsplash.com/photo-1523986371872-9d3ba2e2f642?auto=format&fit=crop&w=1200&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodiExpress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
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
            return FoodCard(
              food: food,
              onTap: () {
                // Navegación por rutas nombradas + arguments (FoodModel).
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: food,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
