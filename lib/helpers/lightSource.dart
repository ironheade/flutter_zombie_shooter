import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';
import 'dart:math';
import 'dart:async';

class LightSource extends CircleComponent
    with CollisionCallbacks, HasGameRef<ShooterGame> {
  late Vector2 playerPosition;
  late double lightRadius;
  late Color primaryLighColour;
  late bool flicker;
  late bool isFlickering;
  late int timeBetweenFlicker;
  late int flickerTimeMS;
  late int numberOfRays;

  late List<RaycastResult<ShapeHitbox>> results;
  List<RaycastResult<ShapeHitbox>> testResults = [];

  late List<ShapeHitbox> ignoreHitboxes;
  RaycastResult<ShapeHitbox>? result;

//  final colorC = Color.alphaBlend();

  LightSource({
    required this.lightRadius,
    required this.playerPosition,
    this.results = const [],
    this.ignoreHitboxes = const [],
    this.numberOfRays = 200,
    this.flicker = false,
    this.isFlickering = false,
    this.primaryLighColour = const Color.fromARGB(
      180,
      255,
      242,
      182,
    ),
  }) : super(
          anchor: Anchor.center,
          radius: lightRadius,
          position: playerPosition,
          paint: Paint()
            ..blendMode = BlendMode.colorDodge
            ..shader = RadialGradient(colors: [
              primaryLighColour,
              primaryLighColour.withOpacity(0)
            ]).createShader(Rect.fromCircle(
              center: Offset(lightRadius, lightRadius),
              radius: lightRadius,
            )),
        );

  @override
  Future<void> onLoad() {
    if (isFlickering) {
      lightFlicker();
    }

    return super.onLoad();
  }

  void changeLight(int A) {
    paint = Paint()
      ..blendMode = BlendMode.colorDodge
      //..colorFilter =          ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.multiply)
      ..shader = RadialGradient(colors: [
        primaryLighColour.withAlpha(A),
        primaryLighColour.withOpacity(0)
      ]).createShader(Rect.fromCircle(
        center: Offset(lightRadius, lightRadius),
        radius: lightRadius,
      ));
  }

  void lightFlicker() {
    Random random = Random();
    Future.delayed(Duration(seconds: random.nextInt(4) + 1), () {
      flicker = true;
      Future.delayed(Duration(milliseconds: random.nextInt(200) + 600), () {
        flicker = false;
        changeLight(primaryLighColour.alpha);
      });
      lightFlicker();
    });
  }

  int i = 0;
  @override
  void update(double dt) {
    super.update(dt);
    //List<RaycastResult<ShapeHitbox>> testResults = [];

    results = gameRef.collisionDetection.raycastAll(position,
        numberOfRays: numberOfRays,
        ignoreHitboxes: ignoreHitboxes,
        out: testResults);

    if (isFlickering) {
      if (flicker) {
        i++;
        if (i > 3) {
          changeLight(Random().nextInt(primaryLighColour.alpha - 50) + 50);
          i = 0;
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    Path cutPath = Path();
    for (var result in results) {
      final intersectionPoint =
          (result.intersectionPoint! + (playerPosition - position));

      final intersectionPointOffset1 = (intersectionPoint +
              ((intersectionPoint - playerPosition)).normalized() *
                  (lightRadius - (intersectionPoint - playerPosition).length))
          .toOffset();

      final intersectionPointOffset2 = intersectionPoint.toOffset();

      Vector2 direction = Vector2(
              intersectionPointOffset2.dy - intersectionPointOffset1.dy,
              (intersectionPointOffset2.dx - intersectionPointOffset1.dx) * -1)
          .normalized();

      cutPath.addPolygon([
        intersectionPointOffset2,
        intersectionPointOffset2 + (direction * 8).toOffset(),
        intersectionPointOffset1 + (direction * 20).toOffset(),
        intersectionPointOffset1,
      ], true);
    }

    //if (1 - cutPath.getBounds().width / (lightRadius * 2) < 0.1) {
    canvas.clipPath(Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(Rect.fromCircle(
              center: Offset(lightRadius, lightRadius), radius: lightRadius)),
        cutPath));
    //}

    super.render(canvas);
  }
}
