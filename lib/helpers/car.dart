import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_zombie_shooter/player.dart';

class Car extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    //debugMode = true;
    angle = pi / 4;
    anchor = Anchor.center;
    add(RectangleHitbox(
        size: Vector2(110, 210) * 1.3,
        position: Vector2(114, 130) * 1.3,
        anchor: Anchor.center,
        isSolid: true));

    //angle = pi;
    sprite = await gameRef.loadSprite('car.png');
    size = sprite!.originalSize * 1.3;
  }
}