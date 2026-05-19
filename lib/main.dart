import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BuscaminasApp());
}

class BuscaminasApp extends StatelessWidget {
  const BuscaminasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas',
      debugShowCheckedModeBanner: false, 
      themeMode: ThemeMode.system, // Tema automático
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),
      home: const SplashScreen(),
    );
  }
}