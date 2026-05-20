import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cell_model.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int rows = 8;
  int cols = 8;
  int totalMines = 20; // Ajustado a los requerimientos oficiales
  
  late List<List<CellModel>> board;
  bool isGameOver = false;
  bool isFirstClick = true;
  bool isLoading = true;
  String numberStyle = 'Clásico'; // Nuevo: Estilo de visualización cargado

  Timer? _timer;
  int _secondsElapsed = 0;
  int flagsPlaced = 0;

  @override
  void initState() {
    super.initState();
    _loadDifficultyAndInit();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadDifficultyAndInit() async {
    final prefs = await SharedPreferences.getInstance();
    String diff = prefs.getString('difficulty') ?? 'Medio';
    numberStyle = prefs.getString('number_style') ?? 'Clásico';

    setState(() {
      if (diff == 'Fácil') {
        rows = 6;
        cols = 6;
        totalMines = 10; // Especificación oficial
      } else if (diff == 'Difícil') {
        rows = 10;
        cols = 10;
        totalMines = 30; // Especificación oficial
      } else {
        rows = 8;
        cols = 8;
        totalMines = 20; // Especificación oficial
      }
      _initializeEmptyBoard();
      isLoading = false;
    });
  }

  void _initializeEmptyBoard() {
    board = List.generate(
      rows, (r) => List.generate(cols, (c) => CellModel(row: r, col: c)),
    );
    isGameOver = false;
    isFirstClick = true;
    _secondsElapsed = 0;
    flagsPlaced = 0;
    _timer?.cancel();
  }

  void _placeMinesAndCalculate(int safeRow, int safeCol) {
    int minesPlaced = 0;
    Random random = Random();
    
    while (minesPlaced < totalMines) {
      int r = random.nextInt(rows);
      int c = random.nextInt(cols);
      
      if (!board[r][c].hasMine && (r != safeRow || c != safeCol)) {
        board[r][c].hasMine = true;
        minesPlaced++;
      }
    }

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!board[r][c].hasMine) {
          board[r][c].adjacentMines = _countAdjacentMines(r, c);
        }
      }
    }
  }

  int _countAdjacentMines(int r, int c) {
    int count = 0;
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int newRow = r + i;
        int newCol = c + j;
        if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
          if (board[newRow][newCol].hasMine) count++;
        }
      }
    }
    return count;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  String get _formattedTime {
    int minutes = _secondsElapsed ~/ 60;
    int seconds = _secondsElapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _toggleFlag(CellModel cell) {
    if (isGameOver || cell.isRevealed) return;

    setState(() {
      cell.isFlagged = !cell.isFlagged;
      cell.isFlagged ? flagsPlaced++ : flagsPlaced--;
    });
  }

  void _revealCell(CellModel cell) {
    if (isGameOver || cell.isRevealed || cell.isFlagged) return;

    if (isFirstClick) {
      isFirstClick = false;
      _placeMinesAndCalculate(cell.row, cell.col);
      _startTimer();
    }

    setState(() {
      cell.isRevealed = true;

      if (cell.hasMine) {
        isGameOver = true;
        _timer?.cancel();
        _revealAll();
        _showEndGameDialog(false);
      } else {
        if (cell.adjacentMines == 0) {
          _floodFill(cell.row, cell.col);
        }
        _checkWinCondition();
      }
    });
  }

  void _floodFill(int r, int c) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int newRow = r + i;
        int newCol = c + j;
        
        if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
          CellModel neighbor = board[newRow][newCol];
          if (!neighbor.isRevealed && !neighbor.hasMine && !neighbor.isFlagged) {
            neighbor.isRevealed = true;
            if (neighbor.adjacentMines == 0) {
              _floodFill(newRow, newCol);
            }
          }
        }
      }
    }
  }

  void _revealAll() {
    for (var row in board) {
      for (var cell in row) {
        cell.isRevealed = true;
      }
    }
  }

  void _checkWinCondition() async {
    int revealedCount = 0;
    for (var row in board) {
      for (var cell in row) {
        if (cell.isRevealed) revealedCount++;
      }
    }
    
    if ((rows * cols) - revealedCount == totalMines) {
      isGameOver = true;
      _timer?.cancel();
      
      final prefs = await SharedPreferences.getInstance();
      String currentDiff = prefs.getString('difficulty') ?? 'Medio';
      String key = 'score_$currentDiff';
      int? previousBest = prefs.getInt(key);
      
      if (previousBest == null || _secondsElapsed < previousBest) {
        await prefs.setInt(key, _secondsElapsed);
      }

      _showEndGameDialog(true);
    }
  }

  void _showEndGameDialog(bool isWin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(isWin ? '¡Ganaste! 🏆' : '¡Fin del Juego! 💥', textAlign: TextAlign.center),
          content: Text(
            isWin 
              ? 'Despejaste el campo en $_formattedTime.\n¡Excelente trabajo!' 
              : 'Pisaste una mina.\n¡Mejor suerte la próxima vez!',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Menú Principal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _initializeEmptyBoard();
                });
              },
              child: const Text('Jugar de nuevo'),
            ),
          ],
        );
      }
    );
  }

  // Lógica de adaptación de fuentes según la configuración de visualización
  TextStyle _getNumberStyle(int minas) {
    FontWeight weight = FontWeight.bold;
    if (numberStyle == 'Retro') {
      weight = FontWeight.w900; // Aspecto pesado y pixelado simulado
    } else if (numberStyle == 'Minimalista') {
      weight = FontWeight.w300; // Aspecto ultra delgado y limpio
    }
    return TextStyle(
      fontSize: 24, 
      fontWeight: weight,
      color: _getNumberColor(minas),
    );
  }

  // Lógica de adaptación de color según la configuración elegida
  Color _getNumberColor(int minas) {
    if (numberStyle == 'Minimalista') return Colors.blueGrey[700]!; // Color homogéneo
    
    if (numberStyle == 'Colorido') {
      switch (minas) {
        case 1: return Colors.cyanAccent[700]!;
        case 2: return Colors.lime[700]!;
        case 3: return Colors.pinkAccent;
        case 4: return Colors.amber[800]!;
        default: return Colors.purpleAccent;
      }
    }
    
    if (numberStyle == 'Retro') {
      switch (minas) {
        case 1: return Colors.blue[900]!;
        case 2: return Colors.green[900]!;
        default: return Colors.red[900]!; // Paleta opaca y limitada
      }
    }

    // Estilo Clásico tradicional
    switch (minas) {
      case 1: return Colors.blue;
      case 2: return Colors.green;
      case 3: return Colors.red;
      case 4: return Colors.purple;
      case 5: return Colors.orange;
      default: return Colors.teal;
    }
  }

  Widget? _buildCellContent(CellModel cell) {
    if (cell.isFlagged) return const Text('🚩', style: TextStyle(fontSize: 24));
    if (cell.isRevealed) {
      if (cell.hasMine) return const Text('💣', style: TextStyle(fontSize: 24));
      if (cell.adjacentMines > 0) {
        return Text(
          '${cell.adjacentMines}',
          style: _getNumberStyle(cell.adjacentMines),
        );
      }
    }
    return null;
  }

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscaminas', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCounter(Icons.flag, (totalMines - flagsPlaced).toString(), Colors.red),
                  _buildCounter(Icons.timer, _formattedTime, Colors.blue),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: cols / rows,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: rows * cols,
                      itemBuilder: (context, index) {
                        int r = index ~/ cols;
                        int c = index % cols;
                        CellModel cell = board[r][c];

                        return GestureDetector(
                          onTap: () => _revealCell(cell),
                          onSecondaryTap: () => _toggleFlag(cell),
                          onLongPress: () => _toggleFlag(cell),
                          child: Container(
                            decoration: BoxDecoration(
                              color: cell.isRevealed 
                                  ? Theme.of(context).cardColor 
                                  : Theme.of(context).primaryColorDark,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.withOpacity(0.5)),
                            ),
                            child: Center(
                              child: _buildCellContent(cell),
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
}