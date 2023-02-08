import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_zombie_shooter/helpers/directions.dart';
import 'package:flutter_zombie_shooter/helpers/weapons.dart';

import 'constants.dart';

class Player extends SpriteAnimationComponent with HasGameRef {
  Player()
      : super(
          size: Vector2.all(kPlayerSize),
          //anchor: Anchor.center
        );

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _moveAnimation;
  late final SpriteAnimation _idleAnimationShotgun;
  late final SpriteAnimation _moveAnimationShotgun;

  final double _animationSpeed = kPlayerAnimationSpeed;
  Direction direction = Direction(leftX: 0, leftY: 0, rightX: 0, rightY: 0);
  double storedAngle = 0;
  Weapon weapon = Weapon.rifle;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then(
      (_) => {
        animation = _idleAnimation,
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
    animation = direction.leftX != 0
        ? weapon == Weapon.rifle
            ? _moveAnimation
            : _moveAnimationShotgun
        : weapon == Weapon.rifle
            ? _idleAnimation
            : _idleAnimationShotgun;
    //animation = direction.leftX != 0 ? _moveAnimation :_idleAnimation ;
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('survivor-idle_rifle.png'),
        columns: 20,
        rows: 1);
    final spriteSheetMove = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('survivor-move_rifle.png'),
        columns: 20,
        rows: 1);
    final spriteSheetShotgun = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('survivor-idle_shotgun.png'),
        columns: 20,
        rows: 1);
    final spriteSheetMoveShotgun = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('survivor-move_shotgun.png'),
        columns: 20,
        rows: 1);
    final spriteSheetFeet = SpriteSheet.fromColumnsAndRows(
        image: await gameRef.images.load('survivor-run_feet.png'),
        columns: 20,
        rows: 1);

    //List<SpriteSheet> spriteSheets = [spriteSheet, spriteSheetMove];
    //final spriteGroup = SpriteAnimationGroupComponent.fromFrameData(image, data)
    //final spriteGroup = SpriteAnimation.spriteList([spriteSheet,spriteSheetMove], stepTime: stepTime)

    _idleAnimation = spriteSheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 19);

    _moveAnimation = spriteSheetMove.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 19, loop: true);

    _idleAnimationShotgun = spriteSheetShotgun.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 19);

    _moveAnimationShotgun = spriteSheetMoveShotgun.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 19, loop: true);
  }
}
