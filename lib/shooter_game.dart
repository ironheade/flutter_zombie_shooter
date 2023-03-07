import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';

import 'package:flutter_zombie_shooter/helpers/enemy_manager.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';

import 'package:flutter_zombie_shooter/helpers/tree_manager.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/world.dart';

class ShooterGame extends FlameGame
    with PanDetector, TapDetector, HasCollisionDetection, HasDecorator {
  final World _world = World();
  final Car _car = Car();

  ValueNotifier<int> kills = ValueNotifier<int>(0);
  ValueNotifier<int> hp = ValueNotifier<int>(kPlayerHealthPoints);

  //ValueNotifier<bool> isPaused = ValueNotifier<bool>(false);

  final Player _player = Player();

  final TreeManager _treeManager = TreeManager();
  //final EnemyManager _enemyManager = EnemyManager(_player);
  Map<Weapon, SpriteSheet> bulletSpriteSheets = {};

  @override
  Future<void> onLoad() async {
    for (Weapon weapon in weaponBulletSprites.keys) {
      bulletSpriteSheets[weapon] = SpriteSheet.fromColumnsAndRows(
          image: await images.load(weaponBulletSprites[weapon]!),
          columns: 1,
          rows: 1);
    }
    overlays.add("Dashboard");
    await add(_world);
    await add(_car);
    await add(_player);
    await add(_treeManager..priority = 4);

    await add(EnemyManager(player: _player));

    _car.position = _world.size / 1.6;
    _player.position = _world.size / 2;
    _player.priority = 3;

    camera.followComponent(_player,
        worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));
  }

  int i = 0;
  onDirectionChanged(Direction direction) {
    if (Vector2(direction.rightX, direction.rightY).length > 0.8 &&
        _player.weapon != Weapon.knife &&
        _player.weapon != Weapon.flashlight) {
      if (i == 0) {
        for (var scatter in scatterBullets[_player.weapon]!) {
          fireBullet(scatter);
        }
      }
      Vector2(direction.leftX, direction.leftY).length != 0
          ? i += 1
          : i += 2; //10ms * 50 = 500ms -> frequency of Bullet
      if (i >= weaponDelaysMS[_player.weapon]!) {
        i = 0;
      }
    }

    _player.direction = direction;
  }

  FutureOr<void> fireBullet(int scatter) {
    return add(Bullet(
      sprite: bulletSpriteSheets[_player.weapon]!.getSpriteById(0),
      player: _player,
      worldSize: _world.size,
      damage: 25,
      directionAngle: _player.absoluteAngle,
    )
      ..directionAngle -= pi / 180 * scatter
      ..angle -= pi / 180 * scatter);
  }

  onWeaponChanged(Weapon weapon) {
    _player.weapon = weapon;
  }
}
