import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 1. Añadimos los servicios de Flutter
import 'screens/splash_screen.dart';

void main() {
  // 2. Nos aseguramos de que Flutter esté inicializado antes de pedirle cambios al sistema
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // 3. Apagamos el menú de clic derecho del navegador
  BrowserContextMenu.disableContextMenu(); 
  
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