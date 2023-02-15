import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/rendering.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flutter_zombie_shooter/helpers/boulder.dart';

import 'package:flutter_zombie_shooter/helpers/enemy_manager.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/helpers/tree.dart';
import 'package:flutter_zombie_shooter/helpers/tree_manager.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/world.dart';

class ShooterGame extends FlameGame
    with PanDetector, TapDetector, HasCollisionDetection, HasDecorator {
  final World _world = World();
  final Boulder _boulder = Boulder();
  final Player _player = Player();

  final TreeManager _treeManager = TreeManager();
  final EnemyManager _enemyManager = EnemyManager();
  //final Zombie _zombie = Zombie(onHit:spillBlood );
  //final List BloodList = [];
  RectangleComponent spillBlood() {
    return RectangleComponent(
      size: Vector2(20, 20),
      position: Vector2(0, 0),
      paint: BasicPalette.red.paint()..style = PaintingStyle.fill,
    );
  }

  Map<Weapon, SpriteSheet> bulletSpriteSheets = {};

  @override
  Future<void> onLoad() async {
    for (Weapon weapon in weaponBulletSprites.keys) {
      bulletSpriteSheets[weapon] = SpriteSheet.fromColumnsAndRows(
          image: await images.load(weaponBulletSprites[weapon]!),
          columns: 1,
          rows: 1);
    }
    super.onLoad();
    //add(ScreenHitbox()); HitBox for the size of the smartphone screen
    await add(_world);

    await add(_boulder);
    await add(_player);

    await add(_treeManager..priority = 4);
    await add(_enemyManager);

    _boulder.anchor = Anchor.bottomRight;

    _boulder.position = _world.size / 1.5;
    _player.position = _world.size / 2;
    _player.priority = 3;

    camera.followComponent(_player,
        worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));
  }

  int i = 0;
  onDirectionChanged(Direction direction) {
    if (sqrt((pow(direction.rightX, 2) + pow(direction.rightY, 2))) > 0.8 &&
        _player.weapon != Weapon.knife &&
        _player.weapon != Weapon.flashlight) {
      if (i == 0) {
        for (var scatter in scatterBullets[_player.weapon]!) {
          add(fireBullet(
              direction, _world.size, _player.position, _player.weapon)
            ..directionAngle -= pi / 180 * scatter
            ..angle -= pi / 180 * scatter);
        }
        /*
        add(fireBullet(direction, _world.size, _player.position, _player.weapon)
          ..directionAngle -= pi / 180 * 20
          ..angle -= pi / 180 * 20);
          */
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
      damage: 25,
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
