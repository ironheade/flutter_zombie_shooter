import 'package:flame/components.dart';

class World extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('map.png');
    size = sprite!.originalSize;
  }
}
