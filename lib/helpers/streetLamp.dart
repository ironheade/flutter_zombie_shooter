import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_zombie_shooter/helpers/playerLight.dart';

class StreetLamp extends PositionComponent {
  late Vector2 streetLampPosition;
  StreetLamp({required this.streetLampPosition})
      : super(position: streetLampPosition, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    super.onLoad();
    parent!
        .add(PlayerLight(lightPosition: streetLampPosition, lightRadius: 200));
    /*add(RectangleHitbox(
        size: Vector2.all(20),
        anchor: Anchor.center,
        position: Vector2.all(0)));*/
    parent!.add(CircleComponent(
        radius: 20,
        position: streetLampPosition,
        anchor: Anchor.center,
        paint: Paint()..color = Color.fromRGBO(39, 39, 39, 1),
        priority: 2));
  }
}
