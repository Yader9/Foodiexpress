import 'package:flutter/material.dart';
import 'package:foodiexpress/features/food_menu/presentation/pages/login_page.dart';
import 'package:foodiexpress/features/food_menu/presentation/pages/signup_page.dart';

class AuthTabPage extends StatelessWidget {
  const AuthTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.login), text: 'Login'),
              Tab(icon: Icon(Icons.person_add), text: 'Sign Up'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LoginPage(),
            SignUpPage(),
          ],
        ),
      ),
    );
  }
}
