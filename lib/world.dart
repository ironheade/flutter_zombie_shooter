import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';

class World extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugMode = true;
    decorator.addLast(PaintDecorator.tint(Color.fromARGB(220, 2, 0, 0)));

    sprite = await gameRef.loadSprite('map2.png');
    size = sprite!.originalSize;
    add(RectangleHitbox(size: size, position: Vector2.all(0)));
  }
}
