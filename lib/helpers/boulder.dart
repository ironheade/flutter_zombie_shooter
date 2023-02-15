import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_zombie_shooter/player.dart';

class Boulder extends SpriteComponent with HasGameRef, CollisionCallbacks {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugMode = true;
    add(RectangleHitbox(isSolid: true));
    angle = pi / 5;
    sprite = await gameRef.loadSprite('boulder.png');
    size = sprite!.originalSize;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other.runtimeType == Player) {
      print("Player off");
      //angle -= 0.5;
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    super.onCollisionStart(intersectionPoints, other);
    if (other.runtimeType == Player) {
      //angle += 0.5;
      print("Player on");
    }
  }
}
