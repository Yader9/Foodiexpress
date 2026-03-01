import 'package:flutter/material.dart';
import 'package:foodiexpress/core/session_timeout.dart';
import 'package:foodiexpress/features/food_menu/presentation/pages/AuthTab_page.dart';
import 'core/app_theme.dart';
import 'features/food_menu/presentation/pages/MainTab_page.dart';
import 'features/food_menu/presentation/pages/detail_page.dart';
import 'features/food_menu/presentation/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FoodiExpressApp());
}

class FoodiExpressApp extends StatelessWidget {
  const FoodiExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SessionTimeout(
     child: MaterialApp(
      title: 'FoodiExpress',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            //Cargar firebase
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),),
              );
            }

            //Usuario logueadio = home
            if (snapshot.hasData) {
              return const MaintabPage();
            }

            //Usuario no log va al login
            return const AuthTabPage();
          }
      ),
      routes: {
        '/detail': (context) => const DetailPage(),
      },
     ),
    );
  }
}