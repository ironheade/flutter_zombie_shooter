import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/widgets.dart';

class MyParallaxComponent extends ParallaxComponent {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [ParallaxImageData("laboratory_map.png")],
      //baseVelocity: Vector2(-0.5, 0),
      velocityMultiplierDelta: Vector2(20, 20),
    );
  }
}
