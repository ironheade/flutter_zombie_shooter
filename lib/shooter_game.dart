import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flutter_zombie_shooter/enemy.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/mapComponents.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';

import 'package:flutter_zombie_shooter/helpers/enemy_manager.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/helpers/playerLight.dart';
import 'package:flutter_zombie_shooter/helpers/streetLamp.dart';

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
  late PlayerLight torch = PlayerLight(
      lightPosition: Vector2.all(500),
      lightRadius: 200,
      playerTorch: true,
      primaryLighColour: Color.fromARGB(172, 182, 255, 249));

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
    await add(_car..priority = 3);
    await add(_player);
    await add(_treeManager..priority = 4);

//head and tail lights of the car
    await add(PlayerLight(
        lightRadius: 70,
        lightPosition:
            Vector2(_world.size.x / 1.6 + 120, _world.size.y / 1.6 - 70))
      ..priority = 1);
    await add(PlayerLight(
        lightRadius: 70,
        lightPosition:
            Vector2(_world.size.x / 1.6 + 75, _world.size.y / 1.6 - 120))
      ..priority = 1);
    await add(PlayerLight(
        lightRadius: 50,
        primaryLighColour: Color.fromARGB(172, 192, 8, 8),
        lightPosition:
            Vector2(_world.size.x / 1.6 - 125, _world.size.y / 1.6 + 80))
      ..priority = 1);
    await add(PlayerLight(
        lightRadius: 50,
        primaryLighColour: Color.fromARGB(172, 192, 8, 8),
        lightPosition:
            Vector2(_world.size.x / 1.6 - 65, _world.size.y / 1.6 + 135))
      ..priority = 1);

    await add(torch..priority = 2);

    await add(EnemyManager(player: _player)..priority = 2);

    for (var streetLampPosition in streetLampPositions) {
      add(StreetLamp(streetLampPosition: streetLampPosition));
    }
    _car.position = _world.size / 1.6;
    _player.position = _world.size / 2;
    torch.position = _player.position;
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
    torch.position = _player.position
        // +Vector2(cos(_player.absoluteAngle), sin(_player.absoluteAngle)) * 80
        ;

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
      ..priority = 3
      ..directionAngle -= pi / 180 * scatter
      ..angle -= pi / 180 * scatter);
  }

  onWeaponChanged(Weapon weapon) {
    _player.weapon = weapon;
  }
}
