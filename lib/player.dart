import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/particles.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/painting.dart';

import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_zombie_shooter/enemy.dart';

import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/actions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/functions/functions.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';
import 'package:flutter_zombie_shooter/helpers/lightSource.dart';
import 'package:flutter_zombie_shooter/helpers/object.dart';
import 'package:flutter_zombie_shooter/helpers/playerLight.dart';
import 'package:flutter_zombie_shooter/helpers/streetLamp.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';
import 'package:flutter_zombie_shooter/world.dart';

import 'enums_and_constants/constants.dart';

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<ShooterGame> {
  Player()
      : super(
          size: Vector2.all(kPlayerSize),
        );

  final double _animationSpeed = kPlayerAnimationSpeed;
  Direction direction = Direction(leftX: 0, leftY: 0, rightX: 0, rightY: 0);
  late LightSource _lightSource = LightSource(
      numberOfRays: 20,
      lightRadius: 300,
      playerPosition: Vector2(300, 300),
      primaryLighColour: Color.fromARGB(132, 248, 246, 206));

  //int HP = kPlayerHealthPoints;
  bool dead = false;
  int kills = 0;
  double offsetX = 0.4;
  double offsetY = 0.6;
  Weapon weapon = Weapon.handgun;
  PlayerAction playerAction = PlayerAction.wait;
  late Map animations;
  List collisionRuntimetypes = [
    Car,
    StreetLamp,
    World,
    MyObject,
    ScreenHitbox,
    Wall,
    RoundObstacle
  ];
  ShapeHitbox playerHitbox = CircleHitbox(isSolid: true);

  double _speed = 300;
  Random _random = Random();

  Vector2 getRandomVector() {
    return Vector2.random(_random) * 500;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //parent!.add(        LightSource(lightRadius: 100, playerPosition: position)..priority = 5);
    //debugMode = true;
/*
    await add(CircleHitbox(isSolid: true)
      ..position = Vector2(
          offsetX * size.x - size.x / 2, offsetY * size.x - size.x / 2));
          */
    await add(playerHitbox
      ..position = Vector2(
          offsetX * size.x - size.x / 2, offsetY * size.x - size.x / 2));
/*
    await parent!.add(_lightSource
      ..priority = 5
      ..position = position
      ..ignoreHitboxes = [playerHitbox]
      ..primaryLighColour = Color.fromARGB(132, 248, 246, 206));
*/
    //await add(PlayerLight(lightPosition: position, lightRadius: 200));
    await _loadAnimations().then(
      (_) => {
        animation = animations[weapon][playerAction],

        anchor = Anchor(offsetX, offsetY), //top left clockwise: 0,0;1,0;1,1;0,1
      },
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (collisionRuntimetypes.contains(other.runtimeType)) {
      for (var resetVector in getResetVector(
          direction: direction,
          intersectionPoints: intersectionPoints,
          position: position,
          size: size)) {
        position = position + resetVector;
      }
    }
  }

  @override
  void update(double dt) {
    final particleComponent = ParticleSystemComponent(
        particle: Particle.generate(
            count: 20,
            lifespan: 0.1,
            generator: (i) {
              return MovingParticle(
                // Will move from corner to corner of the game canvas.
                from: position,
                to: position + (Vector2.random(Random())) * 90,
                child: CircleParticle(
                  radius: 2.0,
                  paint: Paint()..color = Color.fromARGB(255, 181, 7, 7),
                ),
              );
            }));
    //gameRef.add(particleComponent);

    super.update(dt);
    _lightSource.position = position;
    updatePosition(dt);
    if (gameRef.hp.value < 1 && !dead) {
      dead = true;
      //removeFromParent();
      gameRef.EndGame();
    }
  }

  updatePosition(double dt) {
    position +=
        Vector2(direction.leftX, direction.leftY) * (1 + kPlayerSpeedFactor);

    if (playerAction == PlayerAction.reload) {
      Future.delayed(Duration(milliseconds: weaponReloadMS[weapon]!), () {
        if (Vector2(direction.rightX, direction.rightY).length > 0.8) {
          playerAction = PlayerAction.shoot;
        } else if (Vector2(direction.leftX, direction.leftY).length > 0) {
          playerAction = PlayerAction.move;
        } else {
          playerAction = PlayerAction.wait;
        }
      });
    } else {
      if (Vector2(direction.rightX, direction.rightY).length > 0.8) {
        playerAction = PlayerAction.shoot;
      } else if (Vector2(direction.leftX, direction.leftY).length > 0) {
        playerAction = PlayerAction.move;
      } else {
        playerAction = PlayerAction.wait;
      }
    }

    //when there is input from the controllers, the old angle is overwritten
    if (direction.leftX != 0 ||
        direction.leftY != 0 ||
        direction.rightX != 0 ||
        direction.rightY != 0) {
      angle = getPlayerAngle(direction);
    }

    animation = animations[weapon][playerAction];
  }

  Future<void> _loadAnimations() async {
    /*
    ImageComposition composition = ImageComposition()
      ..add(await gameRef.images.load("survivor-move_rifle.png"), position)
      ..add(await gameRef.images.load("survivor-idle_shotgun.png"), position);
*/
    Future<SpriteAnimation> makeAnimation({
      required String spriteSheet,
      required int columns,
      required int rows,
      double stepTimeFactor = 1,
      bool loop = true,
    }) async {
      return SpriteSheet.fromColumnsAndRows(
              image: //await composition.compose(),
                  await gameRef.images.load(spriteSheet),
              columns: columns,
              rows: rows)
          .createAnimation(
              row: 0,
              stepTime: _animationSpeed * stepTimeFactor,
              from: 0,
              to: columns - 1,
              loop: loop);
    }

    animations = {
      Weapon.knife: {
        PlayerAction.wait: await makeAnimation(
            spriteSheet: "survivor-idle_knife.png", columns: 20, rows: 1),
        PlayerAction.move: await makeAnimation(
            spriteSheet: "survivor-move_knife.png", columns: 20, rows: 1),
        PlayerAction.shoot: await makeAnimation(
            spriteSheet: "survivor-meleeattack_knife.png",
            columns: 15,
            rows: 1,
            stepTimeFactor: weaponFireAnimationFactor[Weapon.knife]!),
      },
      Weapon.handgun: {
        PlayerAction.wait: await makeAnimation(
            spriteSheet: "survivor-idle_handgun.png", columns: 20, rows: 1),
        PlayerAction.move: await makeAnimation(
            spriteSheet: "survivor-move_handgun.png", columns: 20, rows: 1),
        PlayerAction.reload: await makeAnimation(
            spriteSheet: "survivor-reload_handgun.png", columns: 15, rows: 1),
        PlayerAction.shoot: await makeAnimation(
            spriteSheet: "survivor-shoot_handgun.png",
            columns: 3,
            rows: 1,
            stepTimeFactor: weaponFireAnimationFactor[Weapon.handgun]!),
      },
      Weapon.rifle: {
        PlayerAction.wait: await makeAnimation(
            spriteSheet: "survivor-idle_rifle.png", columns: 20, rows: 1),
        PlayerAction.move: await makeAnimation(
            spriteSheet: "survivor-move_rifle.png", columns: 20, rows: 1),
        PlayerAction.reload: await makeAnimation(
            spriteSheet: "survivor-reload_rifle.png", columns: 20, rows: 1),
        PlayerAction.shoot: await makeAnimation(
            spriteSheet: "survivor-shoot_rifle.png",
            columns: 3,
            rows: 1,
            stepTimeFactor: weaponFireAnimationFactor[Weapon.rifle]!),
      },
      Weapon.shotgun: {
        PlayerAction.wait: await makeAnimation(
            spriteSheet: "survivor-idle_shotgun.png", columns: 20, rows: 1),
        PlayerAction.move: await makeAnimation(
            spriteSheet: "survivor-move_shotgun.png", columns: 20, rows: 1),
        PlayerAction.reload: await makeAnimation(
            spriteSheet: "survivor-reload_shotgun.png", columns: 20, rows: 1),
        PlayerAction.shoot: await makeAnimation(
            spriteSheet: "survivor-shoot_shotgun.png",
            columns: 3,
            rows: 1,
            stepTimeFactor: weaponFireAnimationFactor[Weapon.shotgun]!),
      },
    };
  }
}
