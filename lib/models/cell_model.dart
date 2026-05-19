class CellModel {
  final int row;
  final int col;
  bool hasMine;
  bool isRevealed;
  bool isFlagged;
  int adjacentMines;

  CellModel({
    required this.row,
    required this.col,
    this.hasMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.adjacentMines = 0,
  });
}