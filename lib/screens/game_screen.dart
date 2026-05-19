import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Configuración inicial (Dificultad Media: 8x8)
  int rows = 8;
  int cols = 8;
  int totalMines = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscaminas', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      // SafeArea evita que el tablero se esconda detrás del notch del celular
      body: SafeArea(
        child: Column(
          children: [
            // Cabecera con contadores (Minas y Tiempo)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCounter(Icons.flag, totalMines.toString(), Colors.red),
                  _buildCounter(Icons.timer, '00:00', Colors.blue),
                ],
              ),
            ),
            
            // El Tablero de Juego
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: cols / rows,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(), // Evita que se haga scroll
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: rows * cols,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Aquí irá la lógica al hacer clic en una casilla
                            print('Clic en la casilla $index');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget de ayuda para los contadores superiores
  Widget _buildCounter(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}