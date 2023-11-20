import 'dart:math';
import 'package:flame/components.dart';

class Blood extends SpriteComponent {
  Vector2 bloodPosition;
  double angle;

  Blood({required this.bloodPosition, Sprite? sprite, required this.angle})
      : super(
            scale: Vector2(0.2, 0.2),
            anchor: Anchor.centerRight,
            sprite: sprite,
            priority: 1,
            position: bloodPosition,
            angle: angle + pi);

  @override
  Future<void> onLoad() async {
    Future.delayed(const Duration(milliseconds: 2500), () {
      removeFromParent();
    });
  }
}
