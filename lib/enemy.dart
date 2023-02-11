import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';

class Zombie extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  double _zombieSpeed = 5;
  double _animationSpeed = kPlayerAnimationSpeed;
  int healthPoints = 100;
  late SpriteAnimation zombieAnimation;

  Zombie()
      : super(
          size: Vector2.all(kPlayerSize),
        );

  Future<void> _loadAnimations() async {
    Future<SpriteAnimation> makeAnimation(
        {required int columns, required int rows}) async {
      return SpriteSheet.fromColumnsAndRows(
              image: //await composition.compose(),
                  await gameRef.images.load("zombie-idle.png"),
              columns: columns,
              rows: rows)
          .createAnimation(
              row: 0, stepTime: _animationSpeed, from: 0, to: columns - 1);
    }

    zombieAnimation = await makeAnimation(columns: 17, rows: 1);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
    await _loadAnimations().then(
      (_) => {
        animation = zombieAnimation,
        anchor = Anchor.center, //top left clockwise: 0,0;1,0;1,1;0,1
      },
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other.runtimeType == Bullet) {
      print("hit: ${(intersectionPoints.first + intersectionPoints.last) / 2}");
      print("center: $position");
      print("other center: ${other.position}");
      healthPoints -= 100;
      if (healthPoints <= 0) {
        //removeFromParent();
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(1, 0) * _zombieSpeed * dt * 0;
  }
}
