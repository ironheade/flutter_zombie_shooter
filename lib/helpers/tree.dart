import 'package:flame/components.dart';

class Tree extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = sprite!.originalSize;
  }

  int i = 0;
  int Sign = 1.sign;
  @override
  void update(double dt) {
    if (i > 300) {
      angle += 0.025 * dt;
    }
    if (i < 300) {
      angle -= 0.025 * dt;
    }
    i++;
    if (i == 600) {
      i = 0;
    }
    ;
  }
}
