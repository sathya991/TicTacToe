import 'package:flutter/material.dart';
import 'package:tictactoe/theBoard.dart';
import 'package:tictactoe/tile_states.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<TileStates> tileStatesList = List.filled(9, TileStates.EMPTY);
  var _curTurn = TileStates.CROSS;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Current Turn: ",
                  style: TextStyle(fontSize: 20),
                ),
                _curTurn == TileStates.CROSS
                    ? Image.asset(
                        'assets/x.png',
                        height: 22,
                        color: Colors.blue,
                      )
                    : Image.asset(
                        'assets/circle.png',
                        height: 22,
                        color: Colors.red,
                      ),
              ],
            ),
            const SizedBox(
              height: 120,
            ),
            Stack(
              children: [
                Image.asset('assets/board.png'),
                _tiles(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tiles() {
    return Builder(builder: (context) {
      final bd = MediaQuery.of(context).size.width;
      final td = bd / 3;
      return Container(
        width: bd,
        height: bd,
        child: Column(
            children: chunks(tileStatesList, 3).asMap().entries.map((entry) {
          final chunkIndex = entry.key;
          final tileStateChunk = entry.value;
          return Row(
            children: tileStateChunk.asMap().entries.map((e) {
              final innerIndex = e.key;
              final titleState = e.value;
              final tileIndex = (chunkIndex * 3) + innerIndex;
              return TheBoard(
                  dim: td,
                  onPressed: () => _setTileState(tileIndex),
                  tileState: titleState);
            }).toList(),
          );
        }).toList()),
      );
    });
  }

  _setTileState(int selectedIndex) {
    if (tileStatesList[selectedIndex] == TileStates.EMPTY) {
      setState(() {
        tileStatesList[selectedIndex] = _curTurn;
        _curTurn = _curTurn == TileStates.CROSS
            ? _curTurn = TileStates.CIRCLE
            : _curTurn = TileStates.CROSS;
      });
    }
    if (_checkWinner() != null) {
      _showWinner(_checkWinner());
    } else {
      if (_checkFullBoard()) {
        setState(() {
          tileStatesList = List.filled(9, TileStates.EMPTY);
          _curTurn = TileStates.CROSS;
        });
      }
    }
  }

  TileStates? _checkWinner() {
    TileStates? winner(int a, int b, int c) {
      if (tileStatesList[a] != TileStates.EMPTY) {
        if ((tileStatesList[a] == tileStatesList[b]) &&
            (tileStatesList[b] == tileStatesList[c])) {
          return tileStatesList[a];
        }
      }
      return null;
    }

    final availableChecks = [
      winner(0, 1, 2),
      winner(
        3,
        4,
        5,
      ),
      winner(6, 7, 8),
      winner(0, 3, 6),
      winner(1, 4, 7),
      winner(2, 5, 8),
      winner(0, 4, 8),
      winner(2, 4, 6),
    ];
    TileStates? curWinner;
    for (int i = 0; i < availableChecks.length; i++) {
      if (availableChecks[i] != null) {
        curWinner = availableChecks[i];
        break;
      }
    }
    return curWinner;
  }

  void _showWinner(TileStates? tileState) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Winner"),
            content: tileState == TileStates.CROSS
                ? Image.asset(
                    'assets/x.png',
                    color: Colors.blue,
                  )
                : Image.asset(
                    'assets/circle.png',
                    color: Colors.red,
                  ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      tileStatesList = List.filled(9, TileStates.EMPTY);
                      _curTurn = TileStates.CROSS;
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text("New Game"))
            ],
          );
        });
  }

  _checkFullBoard() {
    bool completeBoard = true;
    for (int i = 0; i < tileStatesList.length; i++) {
      if (tileStatesList[i] == TileStates.EMPTY) {
        completeBoard = false;
        break;
      }
    }
    return completeBoard;
  }
}
