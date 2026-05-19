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
  // Guarda la nueva dificultad seleccionada por el usuario
  Future<void> _saveDifficulty(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('difficulty', difficulty);
    setState(() {
      _selectedDifficulty = difficulty;
    });
  }