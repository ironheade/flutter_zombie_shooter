import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class FogOfWar extends RectangleComponent {
  late Vector2 fogOfWarSize;
  late Paint fogOfWarPaint;
  late Vector2 playerPosition;
  late double lightRadius;

  FogOfWar({
    required this.fogOfWarSize,
    required this.fogOfWarPaint,
    required this.playerPosition,
    required this.lightRadius,
  }) : super(
            size: fogOfWarSize,
            paint: Paint()..color = Color.fromARGB(0, 0, 0, 0));
  @override
  void render(Canvas canvas) {
    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()
            ..addRect(Rect.fromCenter(
                center: Vector2(playerPosition.x, playerPosition.y).toOffset(),
                width: fogOfWarSize.x,
                height: fogOfWarSize.y)),
          Path()
            ..addOval(Rect.fromCircle(
                center: Vector2(playerPosition.x, playerPosition.y).toOffset(),
                radius: lightRadius)),
        ),
        fogOfWarPaint);
    super.render(canvas);
  }
}
