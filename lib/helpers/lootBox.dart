import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';

class LootBox extends RectangleComponent
    with CollisionCallbacks, HasGameRef<ShooterGame> {
  LootBox()
      : super(
            size: Vector2.all(40),
            paint: Paint()..color = Color.fromARGB(255, 222, 181, 18),
            anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    add(
      TextComponent(
          text: '+50\nmun',
          textRenderer: TextPaint(
            style: TextStyle(color: BasicPalette.black.color),
          ),
          anchor: Anchor.topLeft,
          position: Vector2.all(5),
          size: Vector2.all(10)),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other.runtimeType == Player) {
      removeFromParent();
      gameRef.ammunition.notifyListeners();
      gameRef.magazine.notifyListeners();
      gameRef.ammunition.value[Weapon.rifle] =
          gameRef.ammunition.value[Weapon.rifle]! + 50;
    }
  }
}
