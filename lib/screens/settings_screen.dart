import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; 

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedDifficulty = 'Medio';
  String _selectedStyle = 'Clásico'; // Almacena el estilo visual de los números

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Carga las preferencias guardadas localmente
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDifficulty = prefs.getString('difficulty') ?? 'Medio';
      _selectedStyle = prefs.getString('number_style') ?? 'Clásico';
    });
  }

  // Guarda la dificultad seleccionada
  Future<void> _saveDifficulty(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('difficulty', difficulty);
    setState(() {
      _selectedDifficulty = difficulty;
    });
  }

  // Guarda el estilo visual seleccionado
  Future<void> _saveStyle(String style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('number_style', style);
    setState(() {
      _selectedStyle = style;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apariencia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (_, ThemeMode currentMode, __) {
                  bool isDarkMode = currentMode == ThemeMode.dark;
                  return SwitchListTile(
                    title: const Text('Modo Oscuro', style: TextStyle(fontWeight: FontWeight.bold)),
                    secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                    value: isDarkMode,
                    onChanged: (value) async {
                      // Cambiamos el tema en toda la app instantáneamente
                      themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                      // Guardamos la decisión para la próxima vez
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isDarkMode', value);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dificultad del Juego',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Fácil (6×6 - 10 Minas)'),
                    value: 'Fácil',
                    groupValue: _selectedDifficulty,
                    onChanged: (value) => _saveDifficulty(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Medio (8×8 - 20 Minas)'),
                    value: 'Medio',
                    groupValue: _selectedDifficulty,
                    onChanged: (value) => _saveDifficulty(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Difícil (10×10 - 30 Minas)'),
                    value: 'Difícil',
                    groupValue: _selectedDifficulty,
                    onChanged: (value) => _saveDifficulty(value!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Estilos de Visualización de Números',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Clásico (Colores estándar)'),
                    value: 'Clásico',
                    groupValue: _selectedStyle,
                    onChanged: (value) => _saveStyle(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Colorido (Paleta más vibrante)'),
                    value: 'Colorido',
                    groupValue: _selectedStyle,
                    onChanged: (value) => _saveStyle(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Retro (Estilo pixel con colores opacos)'),
                    value: 'Retro',
                    groupValue: _selectedStyle,
                    onChanged: (value) => _saveStyle(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Minimalista (Números limpios en un solo color)'),
                    value: 'Minimalista',
                    groupValue: _selectedStyle,
                    onChanged: (value) => _saveStyle(value!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}