import 'dart:math';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';

class Bullet extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final double _speed = 1000;
  double directionAngle;

  NotifyingVector2 worldSize;
  NotifyingVector2 playerPosition;

  late SpriteSheet spriteSheet;
  late Weapon weapon;
  int damage;
  //Map<Weapon, Sprite> bulletSpriteSheets = {};

  Bullet({
    required this.damage,
    Sprite? sprite,
    required this.worldSize,
    required this.playerPosition,
    required this.directionAngle,
    required this.weapon,
    //int damage = 25,
  }) : super(
          sprite: sprite,
          position: Vector2(
              playerPosition.x +
                  cos(directionAngle) * bulletOffset[weapon]![Offsets.x]! -
                  sin(directionAngle) * bulletOffset[weapon]![Offsets.y]!,
              playerPosition.y +
                  sin(directionAngle) * bulletOffset[weapon]![Offsets.x]! +
                  cos(directionAngle) * bulletOffset[weapon]![Offsets.y]!),
          size: bulletSize[weapon],
        );

  Vector2 getVecorFromAngle(double directionAngle) {
    return Vector2(cos(directionAngle), sin(directionAngle));
  }

  @override
  Future<void> onLoad() async {
    // _LoadAinmations().then((_) => {sprite = bulletSpriteSheets[weapon]});
    add(RectangleHitbox());
    super.onLoad();
  }

/*
  Future<void> _LoadAinmations() async {
    for (Weapon weapon in weaponBulletSprites.keys) {
      bulletSpriteSheets[weapon] =
          await Sprite.load(weaponBulletSprites[weapon]!);
    }
  }
*/
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other.runtimeType != Bullet) {
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += getVecorFromAngle(directionAngle) * _speed * dt;

    if (position.y < 0 ||
        position.x < 0 ||
        position.y > worldSize.y ||
        position.x > worldSize.x) {
      removeFromParent();
    }
  }
}
