import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/rendering.dart';
import 'package:flame/sprite.dart';
import 'package:flame/src/game/notifying_vector2.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/enemies.dart';
import 'package:flutter_zombie_shooter/functions/functions.dart';
import 'package:flutter_zombie_shooter/helpers/blood.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';

class Zombie extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<ShooterGame> {
  double _animationSpeed = kZombieAnimationSpeed;
  int healthPoints = kZombieHealthpoints;
  double speed = kZombieSpeed;

  int bloodSplashType = Random().nextInt(bloodSpasheTypes.length);
  List<List<Sprite>> bloodSpritesWithColor = [];
  late Player player;
  bool onCollidable = false;
  late SpriteAnimation zombieAnimation;
  late SpriteAnimation zombieAttack;
  late SpriteAnimation zombieRun;
  late Vector2 movementVector;

  final shadowDecorator = Shadow3DDecorator(angle: 180, base: Vector2(50, 50));

  Zombie({required this.player})
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
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //debugMode = true;
    decorator.addLast(PaintDecorator.tint(Color.fromARGB(170, 2, 0, 0)));
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

    add(CircleHitbox()
      ..collisionType = CollisionType.passive
      ..isSolid = true);
    await _loadAnimations().then(
      (_) => {
        animation = zombieAnimation,
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

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other.runtimeType == Car) {
      movementVector = Vector2.all(0);
      onCollidable = true;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other.runtimeType == Car) {
      onCollidable = false;
    }
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

      healthPoints -= 25;
      if (healthPoints <= 0) {
        removeFromParent();
        gameRef.kills.value += 1;
      }
    }

    if (other.runtimeType == Car) {
      Vector2 vectorTowardsBox =
          (intersectionPoints.first + intersectionPoints.last) / 2 - position;
      Vector2 currentMovementVector = (player.position - position);
      double vectorAngle =
          AngleBetweenVectors(vectorTowardsBox, currentMovementVector);
      if (vectorAngle < pi / 2) {
        onCollidable = true;
      }
      if (onCollidable) {
        //Projection of the movement Vector to the resulting vector of both intersection points
        Vector2 directionVector = (player.position - position);
        Vector2 projectionVector =
            intersectionPoints.first - intersectionPoints.last;

        Vector2 newDirectionVector =
            projectVector(directionVector, projectionVector);

        movementVector = newDirectionVector /
            newDirectionVector.length *
            (player.position - position).length;

        //angle between the actual movement vector and the vector between player center and middle of intersection points

        if (vectorAngle > pi / 2) {
          onCollidable = false;
        }
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

    angle = thetaRadians;
    onCollidable ? null : movementVector = (player.position - position);

    Vector2 distanceVector = (player.position - position);

    if (distanceVector.length < 120) {
      i += 1;
      animation = zombieAttack;
      scale = Vector2.all(1.3);
      speed = kZombieSpeed * 0;
      if (i == 30) {
        gameRef.hp.value -= 1;
        //print(player.HP);
        i = 0;
      }
    } else if ((distanceVector.length > 120 && distanceVector.length < 220)) {
      animation = zombieRun;
      scale = Vector2.all(1.3);
      speed = kZombieSpeed * 3;
    } else {
      animation = zombieAnimation;
      scale = Vector2.all(1);
      speed = kZombieSpeed;
    }

    if (movementVector.length > 100) {
      position += movementVector / movementVector.length * speed * dt;
    }
  }
}
