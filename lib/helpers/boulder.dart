import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Boulder extends SpriteComponent with HasGameRef, CollisionCallbacks {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());

    sprite = await gameRef.loadSprite('boulder.png');
    size = sprite!.originalSize;
  }
}
