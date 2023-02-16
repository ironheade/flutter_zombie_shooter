import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/rendering.dart';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'package:flutter_zombie_shooter/enemy.dart';

import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/actions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/functions/functions.dart';

import 'enums_and_constants/constants.dart';

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  Player()
      : super(
          size: Vector2.all(kPlayerSize),
        );

  final double _animationSpeed = kPlayerAnimationSpeed;
  Direction direction = Direction(leftX: 0, leftY: 0, rightX: 0, rightY: 0);
  bool onCollidable = false;
  int playerHealth = 100;
  Weapon weapon = Weapon.handgun;
  PlayerAction playerAction = PlayerAction.wait;
  late Map animations;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    /*
    add(RectangleComponent(
        size: Vector2(100, 12),
        paint: Paint()..color = Colors.green,
        position: position));
        */
    add(CircleHitbox(isSolid: true)..position = Vector2(0.4, 0.6));

    //debugMode = true;
    await _loadAnimations().then(
      (_) => {
        animation = animations[weapon][playerAction],
        anchor = Anchor(0.4, 0.6), //top left clockwise: 0,0;1,0;1,1;0,1
      },
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other.runtimeType != Zombie) {
      Vector2 vectorTowardsBox =
          (intersectionPoints.first + intersectionPoints.last) / 2 - position;
      Vector2 movementVector = Vector2(direction.leftX, direction.leftY);
      double vectorAngle =
          AngleBetweenVectors(vectorTowardsBox, movementVector);
      if (vectorAngle < pi / 2) {
        onCollidable = true;
      }
      if (onCollidable) {
        //Projection of the movement Vector to the resulting vector of both intersection points
        Vector2 directionVector = Vector2(direction.leftX, direction.leftY);
        Vector2 projectionVector =
            intersectionPoints.first - intersectionPoints.last;

        Vector2 newDirectionVector =
            projectVector(directionVector, projectionVector);

        position += newDirectionVector;

        //angle between the actual movement vector and the vector between player center and middle of intersection points

        if (vectorAngle > pi / 2) {
          onCollidable = false;
        }
      }
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other.runtimeType != Zombie) {
      onCollidable = true;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other.runtimeType != Zombie) {
      onCollidable = false;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    updatePosition(dt);
  }

  updatePosition(double dt) {
    if (!onCollidable) {
      position +=
          Vector2(direction.leftX, direction.leftY) * (1 + kPlayerSpeedFactor);
    }

    playerAction = (Vector2(direction.leftX, direction.leftY).length > 0)
        ? playerAction = PlayerAction.move
        : playerAction = PlayerAction.wait;

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
    ImageComposition composition = ImageComposition()
      ..add(await gameRef.images.load("survivor-move_rifle.png"), position)
      ..add(await gameRef.images.load("survivor-idle_shotgun.png"), position);

    Future<SpriteAnimation> makeAnimation(
        {required String spriteSheet,
        required int columns,
        required int rows}) async {
      return SpriteSheet.fromColumnsAndRows(
              image: //await composition.compose(),
                  await gameRef.images.load(spriteSheet),
              columns: columns,
              rows: rows)
          .createAnimation(
              row: 0, stepTime: _animationSpeed, from: 0, to: columns - 1);
    }

    animations = {
      Weapon.knife: {
        PlayerAction.wait: await makeAnimation(
            //spriteSheet: "survivor-idle_knife.png", columns: 20, rows: 1),
            spriteSheet: "zombie-idle.png",
            columns: 20,
            rows: 1),
        PlayerAction.move: await makeAnimation(
            //spriteSheet: "survivor-move_knife.png", columns: 20, rows: 1)
            spriteSheet: "zombie-move.png",
            columns: 17,
            rows: 1)
      },
      Weapon.handgun: {
        PlayerAction.wait: await makeAnimation(
            spriteSheet: "survivor-idle_handgun.png", columns: 20, rows: 1),
        PlayerAction.move: await makeAnimation(
            spriteSheet: "survivor-move_handgun.png", columns: 20, rows: 1)
      },
      Weapon.rifle: {
        PlayerAction.wait: await makeAnimation(
            spriteSheet: "survivor-idle_rifle.png", columns: 20, rows: 1),
        PlayerAction.move: await makeAnimation(
            spriteSheet: "survivor-move_rifle.png", columns: 20, rows: 1)
      },
      Weapon.shotgun: {
        PlayerAction.wait: await makeAnimation(
            spriteSheet: "survivor-idle_shotgun.png", columns: 20, rows: 1),
        PlayerAction.move: await makeAnimation(
            spriteSheet: "survivor-move_shotgun.png", columns: 20, rows: 1)
      },
    };
  }
}
