import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'package:flutter/services.dart';


// 1. Creamos un notificador global que toda la app puede escuchar
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  // 2. Nos aseguramos de que Flutter esté listo antes de leer las preferencias
  WidgetsFlutterBinding.ensureInitialized();

  BrowserContextMenu.disableContextMenu(); 
 
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false;
 
  // Asignamos el tema inicial basado en lo que guardó el usuario
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(const BuscaminasApp());
}

class BuscaminasApp extends StatelessWidget {
  const BuscaminasApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. ValueListenableBuilder reconstruye la app cada vez que el notificador cambia
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, _) {
        return MaterialApp(
          title: 'Buscaminas PWA',
          debugShowCheckedModeBanner: false,
         
          // Configuración de los colores del Modo Claro
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[100],
            cardColor: Colors.white,
            useMaterial3: true,
          ),
         
          // Configuración de los colores del Modo Oscuro
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[900],
            cardColor: Colors.grey[800],
            useMaterial3: true,
          ),
         
          // 4. Aquí aplicamos el tema que el usuario eligió
          themeMode: currentMode,
          home: const SplashScreen(), // Cambia esto si tu primera pantalla se llama distinto
        );
      },
    );
  }
}