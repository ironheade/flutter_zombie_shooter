import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';

import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_zombie_shooter/enemy.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/actions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/mapComponents.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';

import 'package:flutter_zombie_shooter/helpers/enemy_manager.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/helpers/lootBox.dart';
import 'package:flutter_zombie_shooter/helpers/playerLight.dart';
import 'package:flutter_zombie_shooter/helpers/streetLamp.dart';

import 'package:flutter_zombie_shooter/helpers/tree_manager.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/world.dart';

class ShooterGame extends FlameGame
    with
        PanDetector,
        TapDetector,
        HasCollisionDetection,
        HasDecorator,
        HasGameRef<ShooterGame> {
  final World _world = World();
  final Car _car = Car();

  final RectangleComponent _blackoutScreen = RectangleComponent(
    paint: Paint()..color = Color.fromARGB(0, 0, 0, 0),
  );

  late Weapon currentWeapon;
  ValueNotifier<Map<Weapon, int>> magazine = ValueNotifier<Map<Weapon, int>>({
    Weapon.handgun: magazineCapacity[Weapon.handgun] ?? 10,
    Weapon.rifle: magazineCapacity[Weapon.rifle] ?? 10,
    Weapon.shotgun: magazineCapacity[Weapon.shotgun] ?? 10
  });

  ValueNotifier<Map<Weapon, int>> ammunition = ValueNotifier<Map<Weapon, int>>({
    Weapon.handgun: ammunitionCapacity[Weapon.handgun] ?? 10,
    Weapon.rifle: ammunitionCapacity[Weapon.rifle] ?? 10,
    Weapon.shotgun: ammunitionCapacity[Weapon.shotgun] ?? 10
  });

  ValueNotifier<int> kills = ValueNotifier<int>(0);
  ValueNotifier<int> hp = ValueNotifier<int>(kPlayerHealthPoints);

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
    currentWeapon = _player.weapon;

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
    await add(LootBox(LootBoxNumber: 0)
      ..position = Vector2.all(800)
      ..priority = 2);

    await add(EnemyManager(player: _player)..priority = 2);
    //await add(Zombie(player: _player)      ..position = Vector2.all(700)      ..priority = 2);

    for (var streetLampPosition in streetLampPositions) {
      add(StreetLamp(streetLampPosition: streetLampPosition));
    }

    await add(
      _blackoutScreen
        ..priority = 5
        ..position = _world.position
        ..size = _world.size,
    );

    _car.position = _world.size / 1.6;
    _player.position = _world.size / 2;
    torch.position = _player.position;
    _player.priority = 3;

    camera.followComponent(_player,
        worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));
  }

  bool isFiring = false;
  bool loading = false;
  onDirectionChanged(Direction direction) {
    if (Vector2(direction.rightX, direction.rightY).length > 0.8 &&
        !_player.dead &&
        _player.weapon != Weapon.knife &&
        _player.weapon != Weapon.flashlight) {
      if (magazine.value[_player.weapon]! > 0) {
        loading = false;
        _player.playerAction = PlayerAction.shoot;
        if (!isFiring) {
          isFiring = true;
          fireBullet();
          magazine.value[_player.weapon] =
              (magazine.value[_player.weapon]! - 1);
          magazine.notifyListeners();
          Future.delayed(
              Duration(milliseconds: weaponDelaysMS[_player.weapon]!), () {
            isFiring = false;
          });
        }
      } else {
        if (ammunition.value[_player.weapon]! > 0) {
          _player.playerAction = PlayerAction.reload;

          !loading
              ? ammunition.value[_player.weapon] =
                  ammunition.value[_player.weapon]! -
                      magazineCapacity[_player.weapon]!
              : null;
          loading = true;
          Future.delayed(
              Duration(milliseconds: weaponReloadMS[_player.weapon]!), () {
            magazine.value[_player.weapon] = magazineCapacity[_player.weapon]!;
            magazine.notifyListeners();
          });

          ammunition.notifyListeners();
        }
      }
    }

    torch.position = _player.position;
    _player.direction = _player.dead
        ? Direction(leftX: 0, rightX: 0, leftY: 0, rightY: 0)
        : direction;
  }

  FutureOr<void> EndGame() {
    camera.shake(duration: kBlackoutTimeDelay, intensity: 3);

    _blackoutScreen.add(OpacityEffect.by(
      1,
      EffectController(duration: kBlackoutTimeDelay),
    ));
  }

  FutureOr<void> ResetGame() {
    _blackoutScreen.add(OpacityEffect.by(
      -1,
      EffectController(duration: 1.75),
    ));
    hp.value = 100;
    kills.value = 0;
    _player.position = _world.size / 2;
    torch.position = _player.position;
    _player.dead = false;
    _player.weapon = Weapon.handgun;
    ammunition.value = {
      Weapon.handgun: ammunitionCapacity[Weapon.handgun] ?? 10,
      Weapon.rifle: ammunitionCapacity[Weapon.rifle] ?? 10,
      Weapon.shotgun: ammunitionCapacity[Weapon.shotgun] ?? 10
    };
    magazine.value = {
      Weapon.handgun: magazineCapacity[Weapon.handgun] ?? 10,
      Weapon.rifle: magazineCapacity[Weapon.rifle] ?? 10,
      Weapon.shotgun: magazineCapacity[Weapon.shotgun] ?? 10
    };

    add(EnemyManager(player: _player)..priority = 2);
  }

  FutureOr<void> fireBullet() {
    for (var scatter in scatterBullets[_player.weapon]!) {
      add(Bullet(
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
  }

  onWeaponChanged(Weapon weapon) {
    currentWeapon = weapon;
    _player.weapon = weapon;
    magazine.notifyListeners();
    ammunition.notifyListeners();
  }
}
