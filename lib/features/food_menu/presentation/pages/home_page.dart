import 'package:flutter/material.dart';
import '../../data/food_model.dart';
import '../../../../core/database/database_helper.dart';
import '../widgets/food_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      'https://images.unsplash.com/photo-1689793601983-d0ce3178a4e3?auto=format&fit=crop&fm=jpg&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&ixlib=rb-4.1.0&q=60&w=3000',
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
      'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?auto=format&fit=crop&fm=jpg&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8YWxmcmVkbyUyMHBhc3RhfGVufDB8fDB8fHww&ixlib=rb-4.1.0&q=60&w=3000',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              key: ValueKey(food.id),
              food: food,
              onTap: () async {
                await Navigator.pushNamed(context,
                  '/detail',
                  arguments: food);
                setState(() {});
              },
              onFavoriteChanged: () {
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}
