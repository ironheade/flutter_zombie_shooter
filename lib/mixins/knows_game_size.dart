import 'package:flame/components.dart';

mixin KnowsGameSize on Component {
  late Vector2 gameSize;

  void onResize(Vector2 newGameSize) {}
}
