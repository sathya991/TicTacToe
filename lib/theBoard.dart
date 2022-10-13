import 'package:flutter/material.dart';
import 'package:tictactoe/tile_states.dart';

class TheBoard extends StatelessWidget {
  final double dim;
  final VoidCallback onPressed;
  final TileStates tileState;
  const TheBoard(
      {Key? key,
      required this.dim,
      required this.onPressed,
      required this.tileState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dim,
      height: dim,
      child: TextButton(onPressed: onPressed, child: _curTile()),
    );
  }

  Widget _curTile() {
    Widget curTileImage;
    switch (tileState) {
      case TileStates.EMPTY:
        curTileImage = Container();
        break;
      case TileStates.CROSS:
        curTileImage = Image.asset(
          'assets/x.png',
          color: Colors.blue,
        );
        break;
      case TileStates.CIRCLE:
        curTileImage = Image.asset(
          'assets/circle.png',
          color: Colors.red,
        );
        break;
    }
    return curTileImage;
  }
}
