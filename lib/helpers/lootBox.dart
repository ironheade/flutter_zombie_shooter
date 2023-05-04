import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/helpers/car.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';

class LootBox extends SpriteComponent
    with CollisionCallbacks, HasGameRef<ShooterGame> {
  late int LootBoxNumber;
  late Weapon lootBoxWeapon;
  LootBox({required this.LootBoxNumber})
      : super(
            //size: Vector2(50, 40),

            //paint: Paint()..color = Color.fromARGB(255, 222, 181, 18),
            anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    lootBoxWeapon = bulletSize.keys.elementAt(LootBoxNumber);

    //sprite = await Sprite.load('lootBoxSprites.png');
    SpriteSheet mySprite = SpriteSheet.fromColumnsAndRows(
        image: //await composition.compose(),
            await gameRef.images.load('lootBoxSprites.png'),
        columns: 3,
        rows: 1);
    sprite = mySprite.getSprite(0, LootBoxNumber);
    size = Vector2(50, 40);

    add(RectangleHitbox());

    add(
      TextComponent(
          text: '+${lootBoxAdd[lootBoxWeapon]}',
          //\nAK-47

          textRenderer: TextPaint(
            style: TextStyle(color: Color.fromARGB(255, 254, 236, 175)),
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
      gameRef.ammunition.value[lootBoxWeapon] =
          gameRef.ammunition.value[lootBoxWeapon]! + lootBoxAdd[lootBoxWeapon]!;
    }
    if (other.runtimeType == Car) {
      removeFromParent();
    }
  }
}
