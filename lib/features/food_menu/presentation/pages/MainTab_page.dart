import 'package:flutter/material.dart';
import 'home_page.dart';
import 'favorites_page.dart';

class MaintabPage extends StatelessWidget {
  const MaintabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('FoodiExpress'),
            bottom: const TabBar(
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.white,
              tabs: [
              Tab(icon: Icon(Icons.restaurant_menu), text: 'Menu'),
              Tab(icon: Icon(Icons.star), text: 'Favoritos'),
            ],
            ),
          ),
        body: const TabBarView(children: [
          HomePage(),
          FavoritesPage(),
        ],
        ),
        ),
    );
  }
}