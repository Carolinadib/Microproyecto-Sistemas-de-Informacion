import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedDifficulty = 'Medio'; // Valor por defecto

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Carga la dificultad guardada previamente
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDifficulty = prefs.getString('difficulty') ?? 'Medio';
    });
  }

  // Guarda la nueva dificultad seleccionada
  Future<void> _saveDifficulty(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('difficulty', difficulty);
    setState(() {
      _selectedDifficulty = difficulty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dificultad del Juego',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Fácil (6x6 - 6 Minas)'),
                    value: 'Fácil',
                    groupValue: _selectedDifficulty,
                    onChanged: (value) => _saveDifficulty(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Medio (8x8 - 10 Minas)'),
                    value: 'Medio',
                    groupValue: _selectedDifficulty,
                    onChanged: (value) => _saveDifficulty(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Difícil (10x10 - 20 Minas)'),
                    value: 'Difícil',
                    groupValue: _selectedDifficulty,
                    onChanged: (value) => _saveDifficulty(value!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}