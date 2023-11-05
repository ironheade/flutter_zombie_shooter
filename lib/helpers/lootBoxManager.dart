import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'package:flutter_zombie_shooter/helpers/lootBox.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';
import 'package:flutter_zombie_shooter/world.dart';

class lootBoxManager extends Component with HasGameRef<ShooterGame> {
  late Player player;
  late Vector2 worldSize;

  lootBoxManager({required this.player, required this.worldSize}) : super() {}

  @override
  void onMount() {
    super.onMount();
    _spawnLootBox();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.hp.value < 1) {
      removeFromParent();
    }
  }

  void _spawnLootBox() {
    int LootBoxNumber = Random().nextInt(3);
    int spawnTime = Random().nextInt(20);

    Vector2 position = Vector2(
        100 + Random().nextInt(worldSize.x.toInt() - 100).toDouble(),
        100 + Random().nextInt(worldSize.y.toInt() - 100).toDouble());

    Future.delayed(Duration(seconds: spawnTime), () {
      add(LootBox(LootBoxNumber: LootBoxNumber)..position = position);

      _spawnLootBox();
    });
  }
}
