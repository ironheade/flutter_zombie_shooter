import 'dart:math';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_zombie_shooter/enemy.dart';

import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/player.dart';

class Bullet extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final double _speed = 1000;
  double directionAngle;

  NotifyingVector2 worldSize;

  late SpriteSheet spriteSheet;

  late Player player;
  int damage;
  //Map<Weapon, Sprite> bulletSpriteSheets = {};

  Bullet({
    required this.damage,
    required this.player,
    Sprite? sprite,
    required this.worldSize,
    required this.directionAngle,
    //int damage = 25,
  }) : super(
          sprite: sprite,
          position: Vector2(
              player.position.x +
                  cos(player.absoluteAngle) *
                      bulletOffset[player.weapon]![Offsets.x]! -
                  sin(player.absoluteAngle) *
                      bulletOffset[player.weapon]![Offsets.y]!,
              player.position.y +
                  sin(player.absoluteAngle) *
                      bulletOffset[player.weapon]![Offsets.x]! +
                  cos(player.absoluteAngle) *
                      bulletOffset[player.weapon]![Offsets.y]!),
          size: bulletSize[player.weapon],
          angle: player.angle,
          anchor: Anchor.center,
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

    if (other.runtimeType == Zombie) {
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
