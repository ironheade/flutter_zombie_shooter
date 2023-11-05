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
import 'package:flutter_zombie_shooter/enums_and_constants/maps.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';

import 'package:flutter_zombie_shooter/helpers/enemy_manager.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/helpers/lightSource.dart';
import 'package:flutter_zombie_shooter/helpers/lootBox.dart';
import 'package:flutter_zombie_shooter/helpers/lootBoxManager.dart';
import 'package:flutter_zombie_shooter/helpers/object.dart';
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
  final World _world = World(map: maps[2]);
  final Car _car = Car();
  final MyObject _object = MyObject();

  final RectangleComponent _blackoutScreen = RectangleComponent(
    paint: Paint()..color = Color.fromARGB(0, 0, 0, 0),
  );
  Paint paintRay = Paint()..color = Colors.red.withOpacity(0.6);
  RaycastResult<ShapeHitbox>? result;

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
    final paint = Paint()
      ..color = Color.fromARGB(255, 105, 90, 89).withOpacity(1);
    for (Weapon weapon in weaponBulletSprites.keys) {
      bulletSpriteSheets[weapon] = SpriteSheet.fromColumnsAndRows(
          image: await images.load(weaponBulletSprites[weapon]!),
          columns: 1,
          rows: 1);
    }
    currentWeapon = _player.weapon;

    overlays.add("Dashboard");
    await add(_world);
    //await add(_car..priority = 3);
    await add(_player);
    await add(_treeManager..priority = 4);
    await add(
        lootBoxManager(player: _player, worldSize: _world.size)..priority = 2);
    /*await add(LightSource(
        lightRadius: 200,
        playerPosition: _player.position,
        primaryLighColour: Color.fromARGB(255, 206, 107, 107)));*/
    await add(torch);
    //await add(torch..priority = 2);
    //await add(_lightSource..priority = 2);

    //await add(EnemyManager(player: _player)..priority = 2);
    //await add(_object);
    //await add(Zombie(player: _player)      ..position = Vector2.all(700)      ..priority = 2);
    for (var component in _world.map.additionalComponents) {
      add(component);
    }
    await add(CircleComponent(
        radius: 20,
        anchor: Anchor.center,
        position: Vector2(500, 500),
        paint: paint,
        children: [CircleHitbox()]));

    await add(CircleComponent(
        radius: 30,
        anchor: Anchor.center,
        position: Vector2(500, 600),
        paint: paint,
        children: [CircleHitbox()]));

    await add(CircleComponent(
        radius: 30,
        anchor: Anchor.center,
        position: Vector2(300, 600),
        paint: paint,
        children: [CircleHitbox()]));

    await add(CircleComponent(
        radius: 40,
        anchor: Anchor.center,
        position: Vector2(400, 700),
        paint: paint,
        children: [CircleHitbox()]));

    await add(CircleComponent(
        radius: 5,
        anchor: Anchor.center,
        position: Vector2(300, 700),
        paint: paint,
        children: [CircleHitbox()]));
    await add(CircleComponent(
        radius: 5,
        anchor: Anchor.center,
        position: Vector2(280, 700),
        paint: paint,
        children: [CircleHitbox()]));

    await add(CircleComponent(
        radius: 5,
        anchor: Anchor.center,
        position: Vector2(260, 710),
        paint: paint,
        children: [CircleHitbox()]));

    await add(RectangleComponent(
        position: Vector2(300, 800),
        size: Vector2.all(40),
        paint: paint,
        children: [RectangleHitbox()]));

    await add(RectangleComponent(
        position: Vector2(300, 900),
        size: Vector2(80, 10),
        paint: paint,
        angle: pi / 6,
        children: [RectangleHitbox()]));
    await add(RectangleComponent(
        position: Vector2(500, 750),
        size: Vector2(40, 60),
        paint: paint,
        children: [RectangleHitbox()]));
    await add(RectangleComponent(
        position: Vector2(520, 780),
        size: Vector2.all(40),
        paint: paint,
        children: [RectangleHitbox()]));

    await add(RectangleComponent(
        position: Vector2(920, 580),
        size: Vector2.all(40),
        paint: paint,
        children: [RectangleHitbox()]));

    //for (var streetLampPosition in streetLampPositions) {      add(StreetLamp(streetLampPosition: streetLampPosition));    }

    await add(
      _blackoutScreen
        ..priority = 5
        ..position = _world.position
        ..size = _world.size,
    );

    //_car.position = _world.size / 1.6;
    _player.position = _world.size / 2;
    torch.position = _player.position;
    //_lightSource.position = _player.position;
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
    add(lootBoxManager(player: _player, worldSize: _world.size)..priority = 2);
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
