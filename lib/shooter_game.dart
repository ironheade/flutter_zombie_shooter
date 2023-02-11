import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flutter_zombie_shooter/enemy.dart';
import 'package:flutter_zombie_shooter/enemy_manager.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/world.dart';

class ShooterGame extends FlameGame
    with PanDetector, TapDetector, HasCollisionDetection {
  final World _world = World();
  final Player _player = Player();
  final Zombie _zombie = Zombie();

  final EnemyManager _enemyManager = EnemyManager();

  Map<Weapon, SpriteSheet> bulletSpriteSheets = {};

  @override
  Future<void> onLoad() async {
    children.register<Bullet>();
    for (Weapon weapon in weaponBulletSprites.keys) {
      bulletSpriteSheets[weapon] = SpriteSheet.fromColumnsAndRows(
          image: await images.load(weaponBulletSprites[weapon]!),
          columns: 1,
          rows: 1);
    }

    super.onLoad();

    await add(_world);
    await add(_player);
    await add(_zombie);

    //await add(_enemyManager);
    _zombie.position = _world.size / 1.5;
    _player.position = _world.size / 1.5;
    camera.followComponent(_player,
        worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));
  }

/*
  @override
  void update(double dt) {
    super.update(dt);

    final bullets = children.query<Bullet>();
    print(bullets);
    for (final enemy in _enemyManager.children.whereType<Zombie>()) {
      for (final bullet in bullets) {
        if (enemy.containsPoint(_player.position)) {
          enemy.removeFromParent();
          bullet.removeFromParent();
        }
      }
    }
  }
*/
  int i = 0;
  onDirectionChanged(Direction direction) {
    if (sqrt((pow(direction.rightX, 2) + pow(direction.rightY, 2))) > 0.8 &&
        _player.weapon != Weapon.knife &&
        _player.weapon != Weapon.flashlight) {
      if (i == 0) {
        Bullet bullet = fireBullet(
            direction, _world.size, _player.position, _player.weapon);
        add(bullet);
      }
      (direction.leftX != 0 || direction.leftY != 0)
          ? i += 1
          : i += 2; //10ms * 50 = 500ms -> frequency of Bullet
      if (i >= weaponDelaysMS[_player.weapon]!) {
        i = 0;
      }
    }

    _player.direction = direction;
  }

  onWeaponChanged(Weapon weapon) {
    _player.weapon = weapon;
  }

  Bullet fireBullet(
    Direction direction,
    NotifyingVector2 worldSize,
    NotifyingVector2 playerPosition,
    Weapon weapon,
  ) {
    double calculatedAngleRight = atan(direction.rightY / direction.rightX);

    direction.rightX < 0 ? calculatedAngleRight += pi : null;
    return Bullet(
      sprite: bulletSpriteSheets[_player.weapon]!.getSpriteById(0),
      directionAngle: calculatedAngleRight,
      worldSize: worldSize,
      playerPosition: _player.position,
      weapon: _player.weapon,
    )
      ..angle = _player.storedAngle
      ..anchor = Anchor.center;
  }
}
