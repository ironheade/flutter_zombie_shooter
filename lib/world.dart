import 'package:flame/collisions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/maps.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';

class World extends SpriteComponent with HasGameRef<ShooterGame> {
  GameMap map;

  World({required this.map});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //debugMode = true;
    //GameMap map = maps[0];
    decorator.addLast(PaintDecorator.tint(map.decoratorColor));
    //await add(ScreenHitbox());

    sprite = await gameRef.loadSprite(map.background);
    size = sprite!.originalSize;

    for (var hitbox in map.hitboxes) {
      await add(RectangleHitbox(
          position: hitbox.hitboxPosition,
          size: hitbox.hitboxSize,
          angle: hitbox.hitboxAngle));
    }
    for (var hitbox in map.hitboxes) {
      await parent!.add(RectangleComponent(
          position: hitbox.hitboxPosition,
          size: hitbox.hitboxSize,
          angle: hitbox.hitboxAngle,
          paint: Paint()..color = Color.fromARGB(0, 244, 67, 54),
          children: [RectangleHitbox()]));
    }
  }
}
