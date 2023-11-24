import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame/rendering.dart';
import 'package:flame/sprite.dart';
import 'package:flame/src/game/notifying_vector2.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/enemies.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/enemyblood.dart';
import 'package:flutter_zombie_shooter/functions/functions.dart';
import 'package:flutter_zombie_shooter/helpers/blood.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/helpers/object.dart';
import 'package:flutter_zombie_shooter/helpers/streetLamp.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';
import 'package:flutter_zombie_shooter/world.dart';

class ZombieHitbox extends CircleHitbox {
  late double radius;
  ZombieHitbox({required this.radius}) : super(radius: radius);
}

class Zombie extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<ShooterGame> {
  double _animationSpeed = kZombieAnimationSpeed;
  //int healthPoints = kZombieHealthpoints;
  double speed = kZombieSpeed;

  int bloodSplashType = Random().nextInt(bloodSpasheTypes.length);
  List<List<Sprite>> bloodSpritesWithColor = [];
  late Player player;
  late EnemyType enemyType;

  late SpriteAnimation zombieAnimation;
  late SpriteAnimation zombieAttack;
  late SpriteAnimation zombieRun;
  late Vector2 movementVector;
  late int healthPoints;
  late Color zombieFilter;
  late double zombieSpeedFactor;
  late int damage;
  late EnemyDescription enemyDescription;
  Map<EnemyAction, List<SpriteAnimation>> animations = {};
  ShapeHitbox zombieHitbox = CircleHitbox();
  List collisionRuntimetypes = [
    Car,
    StreetLamp,
    World,
    MyObject,
    Wall,
    RoundObstacle
  ];

  final shadowDecorator = Shadow3DDecorator(angle: 180, base: Vector2(50, 50));

  Zombie(
      {required this.player,
      required this.enemyType,
      this.zombieSpeedFactor = 1,
      this.zombieFilter = const Color.fromARGB(170, 2, 0, 0)})
      : super(
          size: Vector2.all(kZombieSize),
        );

  Future<void> _loadAnimations() async {
    Future<SpriteAnimation> makeAnimation(
        {required int columns,
        required int rows,
        required String image,
        required double animationSpeed}) async {
      return SpriteSheet.fromColumnsAndRows(
              image: //await composition.compose(),
                  await gameRef.images.load(image),
              columns: columns,
              rows: rows)
          .createAnimation(
              row: 0, stepTime: animationSpeed, from: 0, to: columns - 1);
    }

    for (var entry in enemyDescription.mapOfAnimation.entries) {
      animations[entry.key] = [
        for (var animation in enemyDescription.mapOfAnimation[entry.key]!)
          await makeAnimation(
              columns: animation.columns,
              rows: 1,
              image: animation.image,
              animationSpeed: _animationSpeed * animation.animationSpeed),
      ];
    }
/*
    animations[EnemyAction.walk] = [
      for (var animation in enemyDescription.mapOfAnimation[EnemyAction.walk]!)
        await makeAnimation(
            columns: animation.columns,
            rows: 1,
            image: animation.image,
            animationSpeed: _animationSpeed * animation.animationSpeed),
    ];
    */

    //{for (var walkAnimation in enemyDescription.mapOfAnimation[EnemyAction.walk]!)
    //{await makeAnimation(columns: columns, rows: rows, image: image, animationSpeed: animationSpeed)}};
/*
    zombieAnimation = await makeAnimation(
        columns: 9,
        rows: 1,
        image: "Zombie_big_hands_walk.png",
        animationSpeed: _animationSpeed * 2);
    zombieAttack = await makeAnimation(
        columns: 9,
        rows: 1,
        image: "Zombie_big_hands_attack.png",
        animationSpeed: _animationSpeed * 2);
    zombieRun = await makeAnimation(
        columns: 9,
        rows: 1,
        image: "Zombie_big_hands_walk.png",
        animationSpeed: _animationSpeed * 2);

    
        zombieAnimation = await makeAnimation(
        columns: 17,
        rows: 1,
        image: "zombie-idle.png",
        animationSpeed: _animationSpeed);
    zombieAttack = await makeAnimation(
        columns: 9,
        rows: 1,
        image: "zombie-attack.png",
        animationSpeed: _animationSpeed * 1.8);
    zombieRun = await makeAnimation(
        columns: 17,
        rows: 1,
        image: "zombie-move.png",
        animationSpeed: _animationSpeed);
         */
  }

  @override
  Future<void> onLoad() async {
    healthPoints = enemies[enemyType]!.healthPoints;
    super.onLoad();
    enemyDescription = enemies[enemyType]!;
    //debugMode = true;
    decorator.addLast(PaintDecorator.tint(zombieFilter));
    for (var bloodSplashColor in bloodSpasheTypes) {
      bloodSpritesWithColor.add(
        [
          for (var bloodSplash in bloodSplashColor)
            await Sprite.load(bloodSplash)
        ],
      );
    }
    /*
    add(ParticleSystemComponent(
        particle: Particle.generate(
            count: 10,
            lifespan: 1,
            generator: (i) {
              return MovingParticle(
                // Will move from corner to corner of the game canvas.
                from: Vector2.all(40),
                to: Vector2(Random().nextInt(20).toDouble(),
                    Random().nextInt(20).toDouble()),
                child: CircleParticle(
                  radius: 2.0,
                  paint: Paint()..color = Color.fromARGB(255, 112, 0, 0),
                ),
              );
            })));
            */
    //add(ZombieHitbox(radius: 10)..priority = 10);
    add(CircleHitbox()
      ..collisionType = CollisionType.passive
      ..isSolid = true
      ..position =
          Vector2(0.3 * size.x - size.x / 2, 0.45 * size.x - size.x / 2));
    await _loadAnimations().then(
      (_) => {
        animation = animations[EnemyAction.walk]![0],
        anchor = Anchor(0.3, 0.45), //top left clockwise: 0,0;1,0;1,1;0,1
        //scale = Vector2.all(0.5)
      },
    );
  }

  void showBeingHit() {
    decorator.addLast(PaintDecorator.tint(Color.fromARGB(170, 154, 18, 18)));
    Future.delayed(Duration(milliseconds: 100), () {
      decorator.removeLast();
    });
  }

  void Bleed(double angle, Set<Vector2> intersectionPoints) {
    add(ParticleSystemComponent(
        particle: Particle.generate(
            count: 100,
            lifespan: 1,
            generator: (i) {
              return MovingParticle(
                from: (size / 2),
                to: //Vector2(Random().nextInt(20).toDouble(),                    Random().nextInt(20).toDouble()),
                    // Vector2(size.x / 2 + cos(angle) * 40,                        size.y / 2 + sin(angle) * 40),

                    Vector2(sin(angle), cos(angle)) * 40,
                child: CircleParticle(
                  radius: 2.0,
                  paint: Paint()..color = Color.fromARGB(255, 18, 131, 22),
                ),
              );
            })));
  }

  void removeHealtPoints({required int removePoints}) {
    print(removePoints);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other.runtimeType == Bullet) {
      showBeingHit();
      //Bleed(other.angle, intersectionPoints);

      parent!.add(Blood(
          bloodPosition:
              (((intersectionPoints.first + intersectionPoints.last) / 2) +
                      position) /
                  2,
          sprite: bloodSpritesWithColor[bloodSplashType]
              [Random().nextInt(bloodSpasheTypes[bloodSplashType].length)],
          angle: other.angle)
        ..priority = 0);

      //healthPoints -= 25;
      if (healthPoints <= 0) {
        removeFromParent();
        gameRef.enemyList.removeWhere((element) => element == this);
        gameRef.kills.value += 1;
      }
    }
    movementVector = (player.position - position).normalized();
    if (collisionRuntimetypes.contains(other.runtimeType)) {
      for (var resetVector in getResetVector(
          direction: Direction(
              leftX: movementVector.x,
              leftY: movementVector.y,
              rightX: 0,
              rightY: 0),
          intersectionPoints: intersectionPoints,
          position: position,
          size: size)) {
        position = position + resetVector;
      }
    }
  }

//movement of Zombie here
  int i = 0;
  @override
  void update(double dt) {
    super.update(dt);
    double deltaX = player.position.x - position.x;
    double deltaY = player.position.y - position.y;
    double thetaRadians = atan2(deltaY, deltaX);

    angle = thetaRadians + enemyDescription.extraRotation;
    movementVector = (player.position - position);

    Vector2 distanceVector = (player.position - position);

    if (distanceVector.length < 120) {
      i += 1;
      animation = animations[EnemyAction.attack]![0];
      //scale = Vector2.all(1.3);
      scale = Vector2.all(
          enemyDescription.mapOfAnimation[EnemyAction.attack]![0].scale);
      speed = kZombieSpeed * 0;
      if (i == 30) {
        gameRef.hp.value -= enemies[enemyType]!.damage;
        gameRef.camera.shake(duration: 0.1, intensity: 1);
        //print(player.HP);
        i = 0;
      }
    } else if ((distanceVector.length > 120 && distanceVector.length < 220)) {
      animation = animations[EnemyAction.run]![0];
      scale = Vector2.all(
          enemyDescription.mapOfAnimation[EnemyAction.run]![0].scale);
      speed = kZombieSpeed * 3 * zombieSpeedFactor;
    } else {
      animation = animations[EnemyAction.walk]![0];
      scale = Vector2.all(
          enemyDescription.mapOfAnimation[EnemyAction.walk]![0].scale);
      //scale = Vector2.all(1);
      speed = kZombieSpeed * zombieSpeedFactor;
    }

    if (movementVector.length > 100) {
      position += movementVector.normalized() * speed * dt;
    }
  }
}
