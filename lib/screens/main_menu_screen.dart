import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'game_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Fondo claro del menú
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BounceInDown(
              child: const Text(
                'MENÚ PRINCIPAL',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 40),
            FadeInLeft(
  delay: const Duration(milliseconds: 200), 
  child: _menuButton('🕹️ Jugar', Colors.green, () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }),
),
            FadeInRight(delay: const Duration(milliseconds: 400), child: _menuButton('🏆 Marcadores', Colors.orange, () {})),
            FadeInLeft(delay: const Duration(milliseconds: 600), child: _menuButton('⚙️ Configuración', Colors.blue, () {})),
            FadeInRight(delay: const Duration(milliseconds: 800), child: _menuButton('📖 Instrucciones', Colors.purple, () {})),
          ],
        ),
      ),
    );
  }

  // Widget personalizado para hacer los botones uniformes y grandes
  Widget _menuButton(String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(250, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}