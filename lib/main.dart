import 'package:flutter/material.dart';
import 'package:foodiexpress/features/food_menu/presentation/pages/favorites_page.dart';

import 'core/app_theme.dart';
import 'features/food_menu/presentation/pages/detail_page.dart';
import 'features/food_menu/presentation/pages/home_page.dart';
import 'features/food_menu/presentation/pages/MainTab_page.dart';

void main() {
  runApp(const FoodiExpressApp());
}

class FoodiExpressApp extends StatelessWidget {
  const FoodiExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodiExpress',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Rutas nombradas según la guía
      initialRoute: '/',
      routes: {
        '/': (context) => const MaintabPage(),
        '/detail': (context) => const DetailPage(),
        '/favorites': (context) => const FavoritesPage(),
      },
    );
  }
}
