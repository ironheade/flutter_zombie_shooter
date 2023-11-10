import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';

class SVGWorld extends SvgComponent with HasGameRef<ShooterGame> {
  late Vector2 mapSize;
  @override
  Future<void> onLoad() async {
    final svgInstance = await Svg.load('background_svg.svg');
    mapSize = Vector2(svgInstance.svgRoot.viewport.viewBox.width,
        svgInstance.svgRoot.viewport.viewBox.height);
    //final size = Vector2.all(100);
    final position = Vector2.all(0);
    final svgComponent = SvgComponent(
      size: Vector2(svgInstance.svgRoot.viewport.viewBox.width,
          svgInstance.svgRoot.viewport.viewBox.height),
      position: position,
      svg: svgInstance,
    );

    add(svgComponent);
    decorator.addLast(PaintDecorator.tint(Color.fromARGB(182, 0, 0, 0)));
  }
}
