import 'dart:math';

enum TileStates { EMPTY, CROSS, CIRCLE }

List<List<TileStates>> chunks(List<TileStates> list, int size) {
  return List.generate(
      (list.length / size).ceil(),
      (index) =>
          list.sublist(index * size, min(index * size + size, list.length)));
}
