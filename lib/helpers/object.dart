import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_zombie_shooter/helpers/playerLight.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';
import 'package:flutter_zombie_shooter/player.dart';

class MyObject extends SpriteComponent with HasGameRef<ShooterGame> {
  @override
  Future<void> onLoad() async {
    double sizeFactor = 0.7;
    position = Vector2.all(200);
    super.onLoad();
    decorator.addLast(PaintDecorator.tint(Color.fromARGB(170, 2, 0, 0)));
    debugMode = true;
    angle = -pi / 4;
    anchor = Anchor.topLeft;

    //add(RectangleHitbox());
    add(PolygonHitbox([
      Vector2(0, 0),
      Vector2(333, 0),
      Vector2(333, 60),
      Vector2(60, 60),
      Vector2(60, 220),
      Vector2(333, 220),
      Vector2(333, 560),
      Vector2(273, 560),
      Vector2(273, 280),
      Vector2(0, 280)
    ])
      ..collisionType = CollisionType.passive);
    //add(RectangleHitbox(        size: Vector2(260, 50), anchor: Anchor.center, isSolid: true));
    sprite = await gameRef.loadSprite('object.png');
    size = sprite!.originalSize * sizeFactor;
  }
}
