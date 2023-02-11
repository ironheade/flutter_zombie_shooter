import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/actions.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';

import 'enums_and_constants/constants.dart';

class Player extends SpriteAnimationComponent with HasGameRef {
  Player()
      : super(
          size: Vector2.all(kPlayerSize),
        );

  final double _animationSpeed = kPlayerAnimationSpeed;
  Direction direction = Direction(leftX: 0, leftY: 0, rightX: 0, rightY: 0);
  double storedAngle = 0;
  Weapon weapon = Weapon.handgun;
  PlayerAction playerAction = PlayerAction.wait;
  late Map animations;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then(
      (_) => {
        animation = animations[weapon][playerAction],
        anchor = Anchor(0.4, 0.6), //top left clockwise: 0,0;1,0;1,1;0,1
      },
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    updatePosition(dt);
  }

  updatePosition(double dt) {
    position.x += direction.leftX * (1 + kPlayerSpeedFactor);
    position.y += direction.leftY * (1 + kPlayerSpeedFactor);

    if (direction.leftX != 0 || direction.leftY != 0) {
      playerAction = PlayerAction.move;
    } else {
      playerAction = PlayerAction.wait;
    }

    double calculatedAngleLeft = atan(direction.leftY / direction.leftX);
    double calculatedAngleRight = atan(direction.rightY / direction.rightX);
    if (direction.rightX != 0 || direction.rightY != 0) {
      if (direction.rightX < 0) {
        angle = calculatedAngleRight + pi;
        storedAngle = calculatedAngleRight + pi;
      } else if (direction.rightX > 0) {
        angle = calculatedAngleRight;
        storedAngle = calculatedAngleRight;
      } else {
        angle = storedAngle;
      }
    } else {
      if (direction.leftX < 0) {
        angle = calculatedAngleLeft + pi;
        storedAngle = calculatedAngleLeft + pi;
      } else if (direction.leftX > 0) {
        angle = calculatedAngleLeft;
        storedAngle = calculatedAngleLeft;
      } else {
        angle = storedAngle;
      }
    }
    animation = animations[weapon][playerAction];
  }

  Future<void> _loadAnimations() async {
    /*
    ImageComposition composition = ImageComposition()
      ..add(await gameRef.images.load("survivor-walk.png"), position)
      ..add(await gameRef.images.load("survivor-idle_shotgun.png"), position);
*/
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
            columns: 17,
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
