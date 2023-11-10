import 'package:flame/collisions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/maps.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';

class Wall extends RectangleComponent {
  late Vector2 wallPosition;
  late Vector2 wallSize;
  late double wallAngle;
  late int wallPriority;
  late Paint wallPaint;
  late List<Component> wallChildren;

  Wall(
      {required this.wallPosition,
      required this.wallSize,
      required this.wallAngle,
      required this.wallPriority,
      required this.wallPaint,
      required this.wallChildren})
      : super(
            position: wallPosition,
            size: wallSize,
            angle: wallAngle,
            priority: wallPriority,
            paint: wallPaint,
            children: wallChildren);
}

class World extends SpriteComponent with HasGameRef<ShooterGame> {
  GameMap map;

  World({required this.map});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //debugMode = true;
    //GameMap map = maps[0];
    decorator.addLast(PaintDecorator.tint(map.decoratorColor));

    //decorator.removeLast();
    await add(ScreenHitbox());

    //sprite = await gameRef.loadSprite(map.background);
    sprite = await gameRef.loadSprite(map.background);
    size = sprite!.originalSize;
/*
    for (var hitbox in map.hitboxes) {
      await parent!.add(RectangleComponent(
          position: hitbox.hitboxPosition,
          size: hitbox.hitboxSize,
          angle: hitbox.hitboxAngle,
          priority: 8,
          paint: Paint()..color = Color.fromARGB(255, 58, 58, 58),
          children: [RectangleHitbox()]));
    }
*/
    for (var hitbox in map.hitboxes) {
      await parent!.add(Wall(
          wallPosition: hitbox.hitboxPosition,
          wallSize: hitbox.hitboxSize,
          wallAngle: hitbox.hitboxAngle,
          wallPriority: 2,
          wallPaint: Paint()..color = Color.fromARGB(255, 0, 0, 0),
          wallChildren: [RectangleHitbox()]));
    }
  }
}
