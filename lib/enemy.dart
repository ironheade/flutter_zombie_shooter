import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/enemies.dart';
import 'package:flutter_zombie_shooter/functions/functions.dart';
import 'package:flutter_zombie_shooter/helpers/blood.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/test.dart';

class Zombie extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  double _animationSpeed = kZombieAnimationSpeed;
  int healthPoints = 100;
  double speed = kZombieSpeed;

  int bloodSplashType = Random().nextInt(bloodSpasheTypes.length);
  List<List<Sprite>> bloodSpritesWithColor = [];
  late Player player;
  bool onCollidable = false;
  late SpriteAnimation zombieAnimation;
  late SpriteAnimation zombieAttack;
  late SpriteAnimation zombieRun;

  Zombie({required this.player})
      : super(
          size: Vector2.all(kZombieSize),
        );

  Future<void> _loadAnimations() async {
    Future<SpriteAnimation> makeAnimation(
        {required int columns,
        required int rows,
        required String image,
        required double animationSpeed}) async {
      return SpriteSheet.fromColumnsAndRows(
              image: //await composition.compose(),
                  await gameRef.images.load(image),
              columns: columns,
              rows: rows)
          .createAnimation(
              row: 0, stepTime: animationSpeed, from: 0, to: columns - 1);
    }

    zombieAnimation = await makeAnimation(
        columns: 17,
        rows: 1,
        image: "zombie-idle.png",
        animationSpeed: _animationSpeed);
    zombieAttack = await makeAnimation(
        columns: 9,
        rows: 1,
        image: "zombie-attack.png",
        animationSpeed: _animationSpeed * 1.8);
    zombieRun = await makeAnimation(
        columns: 17,
        rows: 1,
        image: "zombie-move.png",
        animationSpeed: _animationSpeed);
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

    add(RectangleHitbox()
      ..collisionType = CollisionType.passive
      ..isSolid = true);
    await _loadAnimations().then(
      (_) => {
        animation = zombieAnimation,
        anchor = Anchor(0.3, 0.45), //top left clockwise: 0,0;1,0;1,1;0,1
        //scale = Vector2.all(0.5)
      },
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other.runtimeType == Bullet) {
      parent!.add(Blood(
          bloodPosition:
              (((intersectionPoints.first + intersectionPoints.last) / 2) +
                      position) /
                  2,
          sprite: bloodSpritesWithColor[bloodSplashType]
              [Random().nextInt(bloodSpasheTypes[bloodSplashType].length)],
          angle: other.angle));

      healthPoints -= 25;
      if (healthPoints <= 0) {
        removeFromParent();
      }
    }
    if (other.runtimeType == Car) {}
  }

//movement of Zombie here
  @override
  void update(double dt) {
    super.update(dt);
    double deltaX = player.position.x - position.x;
    double deltaY = player.position.y - position.y;
    double thetaRadians = atan2(deltaY, deltaX);

    angle = thetaRadians;

    if ((position - player.position).length < 120) {
      animation = zombieAttack;
      scale = Vector2.all(1.3);
      speed = kZombieSpeed;
    } else if (((position - player.position).length > 120 &&
        (position - player.position).length < 220)) {
      animation = zombieRun;
      scale = Vector2.all(1.3);
      speed = kZombieSpeed * 3;
    } else {
      animation = zombieAnimation;
      scale = Vector2.all(1);
      speed = kZombieSpeed;
    }

    if ((position - player.position).length > 100) {
      position += (player.position - position) /
          (position - player.position).length *
          speed *
          dt;
    }
    /*
    if (position.x > 1650) {
      removeFromParent();
    }
    */
  }
}
