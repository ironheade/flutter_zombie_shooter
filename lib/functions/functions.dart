import 'dart:math';
import 'package:flame/components.dart';
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
