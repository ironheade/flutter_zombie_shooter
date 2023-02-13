import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
/*
class World extends SpriteAnimationComponent with HasGameRef {
  late SpriteAnimation world;
  World();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _makeAnimation().then((_) => {animation = world, size = Vector2.all(1200)});
    anchor = Anchor.center;

    //sprite = await gameRef.loadSprite('map.png');
    //size = sprite!.originalSize;
  }

  Future<void> _makeAnimation() async {
    world = SpriteSheet.fromColumnsAndRows(
            image: //await composition.compose(),
                await gameRef.images.load("mapSprite.png"),
            columns: 2,
            rows: 1)
        .createAnimation(row: 0, stepTime: 1, from: 0, to: 2);
  }
}
*/

class World extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('map2.png');
    size = sprite!.originalSize;
  }
}
