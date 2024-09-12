import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game.dart';
import 'direction.dart';

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<Game>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFDB096),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              game.resetGame();
            },
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              _move(Direction.right);
            } else {
              _move(Direction.left);
            }
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              _move(Direction.down);
            } else {
              _move(Direction.up);
            }
          }
        },
        child: Container(
          color: const Color(0xFFFDB096),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildScore(game.score),
                SizedBox(height: 20),
                _buildGrid(game),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScore(int score){
    return Text(
      'Score: $score',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xffE5958E),
      ),
    );
  }

  Widget _buildGrid(Game game) {
    const double tileSize = 70.0;
    const double spacing = 3.0;
    const int gridSize = 4;

    return Center(
      child: Container(
        width: gridSize * tileSize + (gridSize - 1) * spacing + 2 * spacing,
        height: gridSize * tileSize + (gridSize - 1) * spacing + 2 * spacing,
        decoration: BoxDecoration(
          color: Color(0xffE5958E),
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.all(spacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(gridSize, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(gridSize, (col) {
                int value = game.board[row][col];
                return Container(
                  width: tileSize,
                  height: tileSize,
                  child: _buildTile(value),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTile(int value) {
    return Container(
      margin: EdgeInsets.all(4.0),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: _getTileColor(value),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          value == 0 ? '' : value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _getTextColor(value),
          ),
        ),
      ),
    );
  }


  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return Color(0xFFECE37E);
      case 4:
        return Color(0xFFBBEC7E);
      case 8:
        return Color(0xFF7EEC94);
      case 16:
        return Color(0xFF7EECCF);
      case 32:
        return Color(0xFF7ECFEC);
      case 64:
        return Color(0xFF7EA5EC);
      case 128:
        return Color(0xFF827EEC);
      case 256:
        return Color(0xFFB37EEC);
      case 512:
        return Color(0xFFD87EEC);
      case 1024:
        return Color(0xFFEC7EBC);
      case 2048:
        return Color(0xFFEC7E7E);
      default:
        return Colors.grey[200]!;
    }
  }

  Color _getTextColor(int value) {
    return Colors.white;
  }

  void _move(Direction direction) {
    final game = Provider.of<Game>(context, listen: false);
    if (game.canMove(direction)) {
      setState(() {
        game.move(direction);
        if (game.checkWin()) {
          _showDialog('Gagné :)');
        } else if (game.checkLoss()) {
          _showDialog('Perdu :(');
        }
      });
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



