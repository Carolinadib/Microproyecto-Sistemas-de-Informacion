import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  int? bestTimeFacil;
  int? bestTimeMedio;
  int? bestTimeDificil;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bestTimeFacil = prefs.getInt('score_Fácil');
      bestTimeMedio = prefs.getInt('score_Medio');
      bestTimeDificil = prefs.getInt('score_Difícil');
    });
  }

  // Elimina todos los registros locales de almacenamiento
  Future<void> _clearAllScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('score_Fácil');
    await prefs.remove('score_Medio');
    await prefs.remove('score_Difícil');
    _loadScores(); // Recarga la vista limpia
  }

  // Muestra cuadro de confirmación para evitar borrados accidentales
  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Borrar todos los marcadores?'),
        content: const Text('Esta acción eliminará de forma permanente tus récords locales.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _clearAllScores();
              Navigator.pop(context);
            },
            child: const Text('Borrar todo', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String formatTime(int? seconds) {
    if (seconds == null) return 'Sin registro';
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Evalúa si no existe ningún puntaje guardado actualmente
    bool hasNoScores = bestTimeFacil == null && bestTimeMedio == null && bestTimeDificil == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Marcadores'),
        centerTitle: true,
        actions: [
          if (!hasNoScores)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              tooltip: 'Borrar marcadores',
              onPressed: _showClearConfirmationDialog,
            )
        ],
      ),
      body: Center(
        child: hasNoScores
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Aún no tienes registros. ¡Juega tu primera partida!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Mejores Tiempos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _scoreCard('Fácil (6×6)', bestTimeFacil, Colors.green),
                  _scoreCard('Medio (8×8)', bestTimeMedio, Colors.orange),
                  _scoreCard('Difícil (10×10)', bestTimeDificil, Colors.red),
                ],
              ),
      ),
    );
  }

  Widget _scoreCard(String title, int? time, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: Icon(Icons.timer, color: color, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        trailing: Text(formatTime(time), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      ),
    );
  }
}