import 'dart:math';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_zombie_shooter/enemy.dart';

import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/helpers/playerLight.dart';
import 'package:flutter_zombie_shooter/helpers/streetLamp.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';
import 'package:flutter_zombie_shooter/world.dart';

class Bullet extends SpriteComponent
    with CollisionCallbacks, HasGameRef<ShooterGame> {
  final double _speed = 1000;
  double directionAngle;
  List collisionRuntimetypes = [World, Zombie, StreetLamp, Wall];
  NotifyingVector2 worldSize;
  late ShapeHitbox bulletHitbox = RectangleHitbox();
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
          //paint: Paint()..color = Color.fromARGB(255, 250, 3, 3),
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
    add(bulletHitbox);
    //print(gameRef.GegnerListe[0].healthPoints-=10);
    //print(gameRef.enemyList.length);

    add(PlayerLight(
        lightPosition: Vector2.all(1),
        lightRadius: 10,
        primaryLighColour: weaponBulletLight[player.weapon]!)
      ..priority = 5);
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (gameRef.enemyList.contains(other)) {
      gameRef
          .enemyList[
              gameRef.enemyList.indexWhere((element) => element == other)]
          .healthPoints -= weaponBulletDamage[player.weapon]!;
    }

    if (collisionRuntimetypes.contains(other.runtimeType)) {
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += getVecorFromAngle(directionAngle) * _speed * dt;
  }
}
