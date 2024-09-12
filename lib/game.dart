import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'direction.dart';

class Game extends ChangeNotifier {
  late List<List<int>> _board;
  static const int _size = 4;
  int _score = 0;

  Game() {
    _initializeBoard();
  }

  List<List<int>> get board => _board;
  int get score => _score;

  void _initializeBoard() {
    _board = List.generate(4, (_) => List.filled(_size, 0));
    _addRandomTile();
    _addRandomTile();
    notifyListeners();
  }

  void resetGame() {
    _initializeBoard();
    notifyListeners();
    _score = 0;
  }

  void _addRandomTile() {
    final emptyTiles = <Map<String, int>>[];
    for (int row = 0; row < _size; row++) {
      for (int col = 0; col < _size; col++) {
        if (_board[row][col] == 0) {
          emptyTiles.add({'row': row, 'col': col});
        }
      }
    }
    if (emptyTiles.isNotEmpty) {
      final randomTile = (emptyTiles..shuffle()).first;
      final rand = Random();
      _board[randomTile['row']!][randomTile['col']!] = (rand.nextDouble() < 0.9) ? 2 : 4;
      notifyListeners();
    }
  }

  void move(Direction direction) {
    switch (direction) {
      case Direction.up:
        _moveUp();
        break;
      case Direction.down:
        _moveDown();
        break;
      case Direction.left:
        _moveLeft();
        break;
      case Direction.right:
        _moveRight();
        break;
    }
    _addRandomTile();
    notifyListeners();
  }

  bool canMove(Direction direction) {
    switch (direction) {
      case Direction.up:
        return _canMoveUp();
      case Direction.down:
        return _canMoveDown();
      case Direction.left:
        return _canMoveLeft();
      case Direction.right:
        return _canMoveRight();
      default:
        return false;
    }  }

  bool checkWin() {
    for (int row = 0; row < _size; row++) {
      for (int col = 0; col < _size; col++) {
        if (_board[row][col] == 2048) return true;
      }
    }
    return false;
  }

  bool checkLoss() {
    if (_board.any((row) => row.contains(0))) return false;

    for (int row = 0; row < _size; row++) {
      for (int col = 0; col < _size; col++) {
        if ((col < _size - 1 && _board[row][col] == _board[row][col + 1]) ||
            (row < _size - 1 && _board[row][col] == _board[row + 1][col])) {
          return false;
        }
      }
    }
    return true;
  }

  void _moveUp() {
    for (int col = 0; col < _size; col++) {
      List<int> column = List.generate(_size, (row) => _board[row][col]);
      column = _mergeRow(column);
      for (int row = 0; row < _size; row++) {
        _board[row][col] = column[row];
      }
    }
  }

  void _moveDown() {
    for (int col = 0; col < _size; col++) {
      List<int> column = List.generate(_size, (row) => _board[_size - 1 - row][col]);
      column = _mergeRow(column);
      for (int row = 0; row < _size; row++) {
        _board[_size - 1 - row][col] = column[row];
      }
    }
  }

  void _moveLeft() {
    for (int row = 0; row < _size; row++) {
      _board[row] = _mergeRow(_board[row]);
    }
  }

  void _moveRight() {
    for (int row = 0; row < _size; row++) {
      List<int> reversedRow = _board[row].reversed.toList();
      reversedRow = _mergeRow(reversedRow);
      _board[row] = reversedRow.reversed.toList();
    }
  }

  List<int> _mergeRow(List<int> row) {
    List<int> newRow = List.filled(_size, 0);
    int index = 0;

    for (int i = 0; i < _size; i++) {
      if (row[i] != 0) {
        if (index > 0 && newRow[index - 1] == row[i]) {
          newRow[index - 1] *= 2;
          _score += newRow[index-1];
        } else {
          newRow[index] = row[i];
          index++;
        }
      }
    }
    return newRow;
  }

  bool _canMoveUp() {
    for (int col = 0; col < _size; col++) {
      List<int> column = List.generate(_size, (row) => _board[row][col]);
      if (_canMergeRow(column)) return true;
    }
    return false;
  }

  bool _canMoveDown() {
    for (int col = 0; col < _size; col++) {
      List<int> column = List.generate(_size, (row) => _board[_size - 1 - row][col]);
      if (_canMergeRow(column)) return true;
    }
    return false;
  }

  bool _canMoveLeft() {
    for (int row = 0; row < _size; row++) {
      if (_canMergeRow(_board[row])) return true;
    }
    return false;
  }

  bool _canMoveRight() {
    for (int row = 0; row < _size; row++) {
      List<int> reversedRow = _board[row].reversed.toList();
      if (_canMergeRow(reversedRow)) return true;
    }
    return false;
  }

  bool _canMergeRow(List<int> row) {
    List<int> mergedRow = _mergeRow(row);
    return !ListEquality().equals(row, mergedRow);
  }

}
