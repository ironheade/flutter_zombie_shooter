import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';
import 'package:flutter_zombie_shooter/helpers/streetLamp.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';

class PlayerLight extends CircleComponent
    with CollisionCallbacks, HasGameRef<ShooterGame> {
  late Vector2 lightPosition;
  late double lightRadius;
  late bool playerTorch;
  late Color primaryLighColour;
  late double bodyWidth;

  Map<int, Vector2> objectsInLight = {};
  List runtimeTypesWithPlayer = [Player, Car, PlayerLight, Bullet];
  List runtimeTypesWithoutPlayer = [Car, PlayerLight, Bullet, StreetLamp];

  PlayerLight(
      {required this.lightPosition,
      required this.lightRadius,
      this.playerTorch = false,
      this.primaryLighColour = const Color.fromARGB(174, 255, 242, 182),
      this.bodyWidth = 15})
      : super(
          anchor: Anchor.center,
          //Anchor(0.3, 0.3),
          radius: lightRadius,
          paint: Paint()
            ..color = Colors.blue
            ..shader = RadialGradient(colors: [
              primaryLighColour,
              primaryLighColour.withOpacity(0)
            ]).createShader(Rect.fromCircle(
              center: Offset(lightRadius, lightRadius),
              radius: lightRadius,
            )),
          position: lightPosition,
        );

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    super.onLoad();
    add(CircleHitbox(isSolid: true));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (playerTorch
        ? !runtimeTypesWithPlayer.contains(other.runtimeType)
        : !runtimeTypesWithoutPlayer.contains(other.runtimeType)) {
      objectsInLight[other.hashCode] = other.position;
      if (other.runtimeType != Bullet) {
        print(other.width);
        print(other.height);
        print(other.angle);
        print(other.position);
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (playerTorch
        ? !runtimeTypesWithPlayer.contains(other.runtimeType)
        : !runtimeTypesWithoutPlayer.contains(other.runtimeType)) {
      objectsInLight.remove(other.hashCode);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final origin = Vector2(200, 200);
  }

  @override
  void render(Canvas canvas) {
    Path cutPath = Path();
    for (var polygon in objectsInLight.values) {
      cutPath.addPolygon(
          getPolygon(lightPosition: position, objectPosition: polygon), true);
    }

    canvas.clipPath(Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(Rect.fromCircle(
              center: Offset(lightRadius, lightRadius), radius: lightRadius)),
        cutPath));
    super.render(canvas);
  }

  List<Offset> getPolygon(
      {required Vector2 lightPosition, required Vector2 objectPosition}) {
    Offset centerOffset = Offset(lightPosition.x, lightPosition.y) -
        Offset(lightRadius, lightRadius);
    Vector2 dirVectorCenter = ((lightPosition - objectPosition) /
        (lightPosition - objectPosition).length);
    Vector2 centerOffset1 = objectPosition +
        Vector2(-dirVectorCenter.y, dirVectorCenter.x) * bodyWidth;
    Vector2 centerOffset2 = objectPosition +
        Vector2(-dirVectorCenter.y, dirVectorCenter.x) * -bodyWidth;
    Vector2 dirVectorOffset1 = ((lightPosition - centerOffset1) /
        (lightPosition - centerOffset1).length);
    Vector2 dirVectorOffset2 = ((lightPosition - centerOffset2) /
        (lightPosition - centerOffset2).length);

    Vector2 playerCenter1 = centerOffset1;
    Vector2 playerCenter2 = centerOffset2;
    Vector2 outerCenterPoint =
        objectPosition - dirVectorCenter * lightRadius * 10;
    Vector2 outerPoint1 = objectPosition +
        Vector2(-dirVectorCenter.y, dirVectorCenter.x) * -20 -
        dirVectorOffset2 * lightRadius * 10;
    Vector2 outerPoint2 = objectPosition +
        Vector2(-dirVectorCenter.y, dirVectorCenter.x) * 20 -
        dirVectorOffset1 * lightRadius * 10;

    return ([
      Offset(playerCenter1.x, playerCenter1.y) - centerOffset,
      Offset(playerCenter2.x, playerCenter2.y) - centerOffset,
      Offset(outerPoint1.x, outerPoint1.y) - centerOffset,
      Offset(outerCenterPoint.x, outerCenterPoint.y) - centerOffset,
      Offset(outerPoint2.x, outerPoint2.y) - centerOffset,
    ]);
  }
}
