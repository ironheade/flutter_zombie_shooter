import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/helpers/directions.dart';
import 'package:flutter_zombie_shooter/helpers/weapons.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/world.dart';
import 'package:flame/sprite.dart';
//import 'package:flame_tiled/flame_tiled.dart';
//import 'package:tiled/tiled.dart' show ObjectGroup, TiledObject;

class ShooterGame extends FlameGame with PanDetector, TapDetector {
  World _world = World();
  Player _player = Player();
  late SpriteSheet spriteSheet;

  @override
  void onTapDown(TapDownInfo info) {
    Bullet bullet = Bullet(
        size: Vector2(50, 25),
        position: _player.position,
        sprite: spriteSheet.getSpriteById(0),
        directionAngle: _player.angle);
    bullet.anchor = Anchor.bottomLeft;
    bullet.angle = _player.storedAngle;

    add(bullet);
  }

  @override
  Future<void> onLoad() async {
    spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await images.load("bullet.png"), columns: 1, rows: 1);

    super.onLoad();

    await add(_world);
    await add(_player);
    _player.position = _world.size / 1.5;
    camera.followComponent(_player,
        worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));
  }

  int i = 0;
  onDirectionChanged(Direction direction) {
    if (sqrt((pow(direction.rightX, 2) + pow(direction.rightY, 2))) > 0.8) {
      if (i == 0) {
        Bullet bullet = fireBullet(direction);

        add(bullet);
      }
      (direction.leftX != 0 || direction.leftY != 0)
          ? i += 1
          : i += 2; //10ms * 50 = 500ms -> frequency of Bullet
      if (i >= 20) {
        i = 0;
      }
    }

    _player.direction = direction;
  }

  onWeaponChanged(Weapon weapon) {
    _player.weapon = weapon;
  }

  Bullet fireBullet(Direction direction) {
    double calculatedAngleRight = atan(direction.rightY / direction.rightX);

    direction.rightX < 0 ? calculatedAngleRight += pi : null;
    return Bullet(
        size: Vector2(10, 5),
        position: Vector2(
            _player.position.x +
                cos(calculatedAngleRight) * 50 -
                sin(calculatedAngleRight) * 12,
            _player.position.y +
                sin(calculatedAngleRight) * 50 +
                cos(calculatedAngleRight) * 12),
        sprite: spriteSheet.getSpriteById(0),
        directionAngle: calculatedAngleRight)
      ..angle = _player.storedAngle
      ..anchor = Anchor.center;
  }
}
