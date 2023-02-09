import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class Bullet extends SpriteComponent {
  double _speed = 450;
  double directionAngle;

  Bullet({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
    required this.directionAngle,
  }) : super(
          sprite: sprite,
          position: position,
          size: size,
        );

  Vector2 getVecorFromAngle(double directionAngle) {
    return Vector2(cos(directionAngle), sin(directionAngle));
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += getVecorFromAngle(directionAngle) * _speed * dt;

    if (position.y < 0) {
      removeFromParent();
    }
  }
}
