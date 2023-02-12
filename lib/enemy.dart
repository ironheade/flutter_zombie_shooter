import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/enemies.dart';
import 'package:flutter_zombie_shooter/helpers/blood.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';

class Zombie extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  double _animationSpeed = kZombieAnimationSpeed;
  int healthPoints = 100;
  //List<Sprite> bloodSprites = [];
  int bloodSplashType = Random().nextInt(bloodSpasheTypes.length);
  List<List<Sprite>> bloodSpritesWithColor = [];

  late SpriteAnimation zombieAnimation;
  //RectangleComponent onHit;

  Zombie()
      : super(
          size: Vector2.all(kZombieSize),
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
    for (var bloodSplashColor in bloodSpasheTypes) {
      bloodSpritesWithColor.add(
        [
          for (var bloodSplash in bloodSplashColor)
            await Sprite.load(bloodSplash)
        ],
      );
    }

    add(RectangleHitbox());
    await _loadAnimations().then(
      (_) => {
        animation = zombieAnimation,
        anchor = Anchor(0.3, 0.45), //top left clockwise: 0,0;1,0;1,1;0,1
      },
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other.runtimeType == Bullet) {
      print(
          "hit at: ${((intersectionPoints.first + intersectionPoints.last) / 2)}");

      print("Angle: ${other.angle * 180 / pi}°");

      parent!.add(Blood(
          bloodPosition: position,
          sprite: bloodSpritesWithColor[bloodSplashType]
              [Random().nextInt(bloodSpasheTypes[bloodSplashType].length)],
          angle: other.angle));

      healthPoints -= 25;
      if (healthPoints <= 0) {
        removeFromParent();
      }
    }
  }

//movement of Zombie here
  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(1, 0) * kZombieSpeed * dt;
  }
}
