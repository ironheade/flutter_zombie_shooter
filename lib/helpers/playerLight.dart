import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/enemy.dart';
import 'package:flutter_zombie_shooter/helpers/bullet.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';
import 'package:flutter_zombie_shooter/helpers/streetLamp.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';
import 'package:flutter_zombie_shooter/world.dart';

class ShadowObject {
  late Set<Vector2> intersectionPoints;
  late PositionComponent other;
  ShadowObject({required this.intersectionPoints, required this.other});
}

class PlayerLight extends CircleComponent
    with CollisionCallbacks, HasGameRef<ShooterGame> {
  late Vector2 lightPosition;
  late double lightRadius;
  late bool playerTorch;
  late Color primaryLighColour;
  late double bodyWidth;

  Map<int, Vector2> objectsInLight = {};
  //Map<int, List<ShadowObject>> objectsInLightComplete = {};
  Map<int, PositionComponent> objectsInLightComplete = {};
  Map<int, Set<Vector2>> objectsInLightIntersectionpoints = {};

  List runtimeTypesWithPlayer = [
    Player,
    Car,
    PlayerLight,
    Bullet,
    ScreenHitbox,

    //Zombie
  ];

  List runtimeTypesWithoutPlayer = [
    Car,
    PlayerLight,
    Bullet,
    StreetLamp,

    //Zombie
  ];

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
            ..blendMode = BlendMode.colorDodge
            ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 8.0)
            ..shader = RadialGradient(colors: [
              primaryLighColour.withOpacity(0),
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
      objectsInLightComplete[other.hashCode] = other;
      objectsInLightIntersectionpoints[other.hashCode] = intersectionPoints
          //ShadowObject(intersectionPoints: intersectionPoints, other: other)
          ;
      if (other.runtimeType != Bullet) {}
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (playerTorch
        ? !runtimeTypesWithPlayer.contains(other.runtimeType)
        : !runtimeTypesWithoutPlayer.contains(other.runtimeType)) {
      objectsInLight.remove(other.hashCode);
      objectsInLightComplete.remove(other.hashCode);
    }
  }

  @override
  void render(Canvas canvas) {
    Path cutPathCircle = Path();
    Path cutPathRectangle = Path();
    Path cutTotalLongRectangle = Path();
    Path cutTotalLongPartialRectangle = Path();
    /*
    Path cutPathRectangleWall = Path();
    Path cutTotalLongRectangleWall = Path();
    Path cutTotalLongPartialRectangleWall = Path();
    */
    for (var polygon in objectsInLightComplete.values) {
      if (polygon.children.toString() == "(Instance of 'CircleHitbox')") {
        if ((polygon.center - position).length < lightRadius) {
          polygon.toString() == "Instance of 'Zombie'"
              ? cutPathCircle.addPolygon(
                  getPolygonCircle(
                      lightPosition: position,
                      objectPosition: polygon.position,
                      radius: 20),
                  true)
              : cutPathCircle.addPolygon(
                  getPolygonCircle(
                      lightPosition: position,
                      objectPosition: polygon.position,
                      radius: polygon.height / 2),
                  true);
        }
      } else {
        Vector2 PointA = polygon.center -
            Vector2(
                cos(polygon.angle) * polygon.width / 2 -
                    sin(polygon.angle) * polygon.height / 2,
                cos(polygon.angle) * polygon.height / 2 +
                    sin(polygon.angle) * polygon.width / 2);
        Vector2 PointB = polygon.center +
            Vector2(
                cos(polygon.angle) * polygon.width / 2 +
                    sin(polygon.angle) * polygon.height / 2,
                -cos(polygon.angle) * polygon.height / 2 +
                    sin(polygon.angle) * polygon.width / 2);
        Vector2 PointC = polygon.center +
            Vector2(
                cos(polygon.angle) * polygon.width / 2 -
                    sin(polygon.angle) * polygon.height / 2,
                cos(polygon.angle) * polygon.height / 2 +
                    sin(polygon.angle) * polygon.width / 2);
        Vector2 PointD = polygon.center +
            Vector2(
                -cos(polygon.angle) * polygon.width / 2 -
                    sin(polygon.angle) * polygon.height / 2,
                cos(polygon.angle) * polygon.height / 2 -
                    sin(polygon.angle) * polygon.width / 2);

        List<Vector2> RectanglePoints = [PointA, PointB, PointC, PointD];
        List<double> RectangleAngles = [
          angleTo(PointA),
          angleTo(PointB),
          angleTo(PointC),
          angleTo(PointD)
        ];

        Vector2 EdgePointA = RectanglePoints[
            RectangleAngles.indexOf(RectangleAngles.reduce(max))];
        Vector2 EdgePointB = RectanglePoints[
            RectangleAngles.indexOf(RectangleAngles.reduce(min))];

        //Both Edge Points in light
        if ((EdgePointA - position).length < lightRadius &&
            (EdgePointB - position).length < lightRadius) {
          //Both Edge Points in light
          List<double> EdgeDistances =
              RectanglePoints.map((e) => position.distanceTo(e)).toList();

          Vector2 closesPoint =
              RectanglePoints[EdgeDistances.indexOf(EdgeDistances.reduce(min))];
          Vector2 EdgePointC =
              RectanglePoints[EdgeDistances.indexOf(EdgeDistances.reduce(max))];
          cutPathRectangle.addPolygon(
              getPolygonRectangle(
                  lightPosition: position,
                  objectPosition: polygon.position,
                  edgePointA: EdgePointA,
                  edgePointB: EdgePointB,
                  closesPoint: closesPoint),
              true);
          /*
          if (polygon.runtimeType == Wall) {
            cutPathRectangleWall.addPolygon(
                getPolygonRectangle(
                    lightPosition: position,
                    objectPosition: polygon.position,
                    edgePointA: EdgePointA,
                    edgePointB: EdgePointB,
                    closesPoint: closesPoint),
                true);
          }*/
        }
        //No Edge Points in light
        else if ((EdgePointA - position).length > lightRadius &&
            (EdgePointB - position).length > lightRadius) {
          List<Vector2> intersectionPointList = (intersections(
              CircleComponent(
                  anchor: Anchor.center,
                  radius: lightRadius,
                  position: position),
              PolygonComponent([PointA, PointB, PointC, PointD]))).toList();

          List<double> intersectionPointAngleList =
              intersectionPointList.map((e) => angleTo(e)).toList();

          if (intersectionPointAngleList.isNotEmpty) {
            Vector2 EdgePointA = intersectionPointList[
                intersectionPointAngleList
                    .indexOf(intersectionPointAngleList.reduce(min))];
            Vector2 EdgePointB = intersectionPointList[
                intersectionPointAngleList
                    .indexOf(intersectionPointAngleList.reduce(max))];

            List<double> EdgeDistances =
                RectanglePoints.map((e) => position.distanceTo(e)).toList();

            Vector2 closesPoint = RectanglePoints[
                EdgeDistances.indexOf(EdgeDistances.reduce(min))];
            cutTotalLongRectangle.addPolygon(
                getPolygonRectangle(
                    lightPosition: position,
                    objectPosition: polygon.position,
                    edgePointA: EdgePointA,
                    edgePointB: EdgePointB,
                    closesPoint: closesPoint),
                true);
            /*
            if (polygon.runtimeType == Wall) {
              cutTotalLongRectangleWall.addPolygon(
                  getPolygonRectangle(
                      lightPosition: position,
                      objectPosition: polygon.position,
                      edgePointA: EdgePointA,
                      edgePointB: EdgePointB,
                      closesPoint: closesPoint),
                  true);
                  
            }
          }*/
          }
        }
        //One Edge Point in light

        else {
          List<Vector2> intersectionPointList = (intersections(
              CircleComponent(
                  anchor: Anchor.center,
                  radius: lightRadius,
                  position: position),
              PolygonComponent([PointA, PointB, PointC, PointD]))).toList();
          Vector2 newEdgePoint = intersectionPointList.first;
          if (position.distanceTo(EdgePointA) > lightRadius) {
            EdgePointA = newEdgePoint;
          }
          if (position.distanceTo(EdgePointB) > lightRadius) {
            EdgePointB = newEdgePoint;
          }

          List<double> EdgeDistances =
              RectanglePoints.map((e) => position.distanceTo(e)).toList();

          Vector2 closesPoint =
              RectanglePoints[EdgeDistances.indexOf(EdgeDistances.reduce(min))];
          cutTotalLongPartialRectangle.addPolygon(
              getPolygonRectangle(
                  lightPosition: position,
                  objectPosition: polygon.position,
                  edgePointA: EdgePointA,
                  edgePointB: EdgePointB,
                  closesPoint: closesPoint),
              true);
/*
          if (polygon.runtimeType == Wall) {
            cutTotalLongPartialRectangleWall.addPolygon(
                getPolygonRectangle(
                    lightPosition: position,
                    objectPosition: polygon.position,
                    edgePointA: EdgePointA,
                    edgePointB: EdgePointB,
                    closesPoint: closesPoint),
                true);
                */

        }
      }
    }

    Path joineCutPathA =
        Path.combine(PathOperation.union, cutPathCircle, cutPathRectangle);
    Path joineCutPathB = Path.combine(PathOperation.union,
        cutTotalLongPartialRectangle, cutTotalLongRectangle);
    Path joineCutPath =
        Path.combine(PathOperation.union, joineCutPathA, joineCutPathB);

    Paint newPaint = Paint()
      ..blendMode = BlendMode.colorDodge
      //..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0)
      ..shader = RadialGradient(colors: [
        primaryLighColour.withOpacity(0.5),
        //Color.fromARGB(255, 0, 0, 0)
        primaryLighColour.withOpacity(0)
      ]).createShader(Rect.fromCircle(
        center: Offset(lightRadius, lightRadius),
        radius: lightRadius,
      ));

    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()
            ..addOval(Rect.fromCircle(
                center: Offset(lightRadius, lightRadius), radius: lightRadius)),
          joineCutPath,
        ),
        newPaint);

    //this Part cuts out shadows completely. Should not count for objects that are not Wall
    /*
    canvas.drawPath(
        Path.combine(
          PathOperation.intersect,
          joineCutPathWalls,
          Path()
            ..addOval(Rect.fromCircle(
                center: Offset(lightRadius, lightRadius), radius: lightRadius)),
        ),
        Paint()..color = Color.fromARGB(255, 0, 0, 0));
        */

    super.render(canvas);
  }

  List<Offset> getPolygonRectangle(
      {required Vector2 lightPosition,
      required Vector2 objectPosition,
      required Vector2 edgePointA,
      required Vector2 edgePointB,
      //required Vector2 edgePointC,
      required Vector2 closesPoint}) {
    Offset centerOffset =
        lightPosition.toOffset() - Offset(lightRadius, lightRadius);
    Vector2 dirVectorCenter = (lightPosition - objectPosition).normalized();

    Vector2 dirVectorOffset1 = (lightPosition - edgePointA).normalized();
    Vector2 dirVectorOffset2 = (lightPosition - edgePointB).normalized();
    //Vector2 dirVectorOffsetMiddle = (lightPosition - edgePointC).normalized();

    Vector2 outerCenterPoint =
        objectPosition - dirVectorCenter * lightRadius * 10;
    Vector2 outerPoint1 = edgePointB - dirVectorOffset2 * lightRadius * 10;
    Vector2 outerPoint2 = edgePointA - dirVectorOffset1 * lightRadius * 10;
    //Vector2 outerPointMiddle =        edgePointC - dirVectorOffsetMiddle * lightRadius * 10;

    return ([
      edgePointA.toOffset() - centerOffset,
      //Offset(closesPoint.x, closesPoint.y) - centerOffset,
      edgePointB.toOffset() - centerOffset,
      outerPoint1.toOffset() - centerOffset,
      outerCenterPoint.toOffset() - centerOffset,
      //Offset(outerPointMiddle.x, outerPointMiddle.y) - centerOffset,
      outerPoint2.toOffset() - centerOffset,
    ]);
  }

/*
  List<Offset> getPolygonRectangle(
      {required Vector2 lightPosition,
      required Vector2 objectPosition,
      required Vector2 edgePointA,
      required Vector2 edgePointB,
      required Vector2 closesPoint}) {
    Offset centerOffset = Offset(lightPosition.x, lightPosition.y) -
        Offset(lightRadius, lightRadius);
    Vector2 dirVectorCenter = ((lightPosition - objectPosition) /
        (lightPosition - objectPosition).length);
    Vector2 centerOffset1 = edgePointA;
    Vector2 centerOffset2 = edgePointB;
    Vector2 dirVectorOffset1 = ((lightPosition - centerOffset1) /
        (lightPosition - centerOffset1).length);
    Vector2 dirVectorOffset2 = ((lightPosition - centerOffset2) /
        (lightPosition - centerOffset2).length);

    Vector2 playerCenter1 = centerOffset1;
    Vector2 playerCenter2 = centerOffset2;
    Vector2 outerCenterPoint =
        objectPosition - dirVectorCenter * lightRadius * 10;
    Vector2 outerPoint1 = objectPosition +
        Vector2(-dirVectorCenter.y, dirVectorCenter.x)  * -20 -
        dirVectorOffset2 * lightRadius * 10;
    Vector2 outerPoint2 = objectPosition +
        Vector2(-dirVectorCenter.y, dirVectorCenter.x) * 20 -
        dirVectorOffset1 * lightRadius * 10;

    return ([
      Offset(playerCenter1.x, playerCenter1.y) - centerOffset,
      //Offset(closesPoint.x, closesPoint.y) - centerOffset,
      Offset(playerCenter2.x, playerCenter2.y) - centerOffset,
      Offset(outerPoint1.x, outerPoint1.y) - centerOffset,
      Offset(outerCenterPoint.x, outerCenterPoint.y) - centerOffset,
      Offset(outerPoint2.x, outerPoint2.y) - centerOffset,
    ]);
  }
*/
  List<Offset> getPolygonCircle(
      {required Vector2 lightPosition,
      required Vector2 objectPosition,
      required double radius}) {
    Offset centerOffset =
        lightPosition.toOffset() - Offset(lightRadius, lightRadius);
    Vector2 dirVectorCenter = (lightPosition - objectPosition).normalized();
    Vector2 edgePointA = objectPosition +
        Vector2(-dirVectorCenter.y, dirVectorCenter.x) * radius;
    Vector2 edgePointB = objectPosition +
        Vector2(dirVectorCenter.y, -dirVectorCenter.x) * radius;
    Vector2 dirVectorOffset1 = (lightPosition - edgePointA).normalized();
    Vector2 dirVectorOffset2 = (lightPosition - edgePointB).normalized();

    Vector2 outerCenterPoint =
        objectPosition - dirVectorCenter * lightRadius * 10;
    Vector2 outerPoint1 = edgePointB - dirVectorOffset2 * lightRadius * 10;
    Vector2 outerPoint2 = edgePointA - dirVectorOffset1 * lightRadius * 10;

    return ([
      edgePointA.toOffset() - centerOffset,
      edgePointB.toOffset() - centerOffset,
      outerPoint1.toOffset() - centerOffset,
      outerCenterPoint.toOffset() - centerOffset,
      outerPoint2.toOffset() - centerOffset,
    ]);
  }
}
