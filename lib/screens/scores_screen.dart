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

  String formatTime(int? seconds) {
    if (seconds == null) return 'Sin registro';
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏆 Marcadores')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Mejores Tiempos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _scoreCard('Fácil (6x6)', bestTimeFacil, Colors.green),
            _scoreCard('Medio (8x8)', bestTimeMedio, Colors.orange),
            _scoreCard('Difícil (10x10)', bestTimeDificil, Colors.red),
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