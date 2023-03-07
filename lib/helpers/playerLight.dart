import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerLight extends CircleComponent {
  late Vector2 lightPosition;
  PlayerLight({required this.lightPosition})
      : super(
          anchor: Anchor(0.3, 0.3),
          radius: 280,
          paint: Paint()
            ..color = Colors.blue
            ..shader = RadialGradient(colors: [
              Color.fromARGB(174, 255, 242, 182),
              Color.fromARGB(0, 255, 255, 255)
            ]).createShader(Rect.fromCircle(
              center: Offset(280, 280),
              radius: 280,
            )),
          position: lightPosition,
        );
}
