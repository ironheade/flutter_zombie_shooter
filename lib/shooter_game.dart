import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flutter_zombie_shooter/helpers/directions.dart';
import 'package:flutter_zombie_shooter/helpers/weapons.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/world.dart';

class ShooterGame extends FlameGame with KeyboardEvents {
  World _world = World();
  Player _player = Player();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(_world);
    await add(_player);
    _player.position = _world.size / 1.5;
    camera.followComponent(_player,
        worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));
  }

  onDirectionChanged(Direction direction) {
    _player.direction = direction;
  }

  onWeaponChanged(Weapon weapon) {
    print("weapon: ${weapon.toString()}");
    _player.weapon = weapon;
  }
}
