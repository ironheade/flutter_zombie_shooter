import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';

double AngleBetweenVectors(Vector2 vector1, Vector2 vector2) {
  return acos((vector1.x * vector2.x + vector1.y * vector2.y) /
      (sqrt(pow(vector1.x, 2) + pow(vector1.y, 2)) *
          sqrt(pow(vector2.x, 2) + pow(vector2.y, 2))));
}

//project vector 1 on vector 2
Vector2 projectVector(Vector2 vector1, Vector2 vector2) {
  return vector2 * dot2(vector1, vector2) / vector2.length2;
}

double getPlayerAngle(Direction direction) {
  double calculatedAngleLeft = atan(direction.leftY / direction.leftX);
  double calculatedAngleRight = atan(direction.rightY / direction.rightX);
  double angle = 0;
  if (Vector2(direction.rightX, direction.rightY).length != 0) {
    if (direction.rightX < 0) {
      angle = calculatedAngleRight + pi;
    } else if (direction.rightX > 0) {
      angle = calculatedAngleRight;
    }
  } else {
    if (direction.leftX < 0) {
      angle = calculatedAngleLeft + pi;
    } else if (direction.leftX > 0) {
      angle = calculatedAngleLeft;
    }
  }
  return angle;
}

List<Vector2> getResetVector(
    {required Set<Vector2> intersectionPoints,
    required Vector2 position,
    required Vector2 size,
    required Direction direction}) {
  List<Vector2> resetVectors = [];
  int loops = intersectionPoints.length ~/ 2;

  var i = 0;
  while (i < loops) {
    Vector2 middlePoint = (intersectionPoints.elementAt(i * 2) +
            intersectionPoints.elementAt(i * 2 + 1)) /
        2;

    double resetVectorLength = (size.x / 2 - position.distanceTo(middlePoint));
    double widthIntersect = intersectionPoints
        .elementAt(i * 2)
        .distanceTo(intersectionPoints.elementAt(i * 2 + 1));
    double X = direction.leftX * (1 + kPlayerSpeedFactor);
    double Y = direction.leftY * (1 + kPlayerSpeedFactor);

    Vector2 resetVectorDirection = (position - middlePoint).normalized();
    double newDistance =
        projectVector(Vector2(X, Y), resetVectorDirection).length;
    //Vector2 resetVector = resetVectorDirection * resetVectorLength;
    Vector2 resetVector = resetVectorDirection * newDistance;
    resetVectors.add(resetVector);
    i += 1;
  }

  return resetVectors;
}
