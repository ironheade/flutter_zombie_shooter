import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter_zombie_shooter/enemy.dart';

class EnemyManager extends Component with CollisionCallbacks {
  late Timer _timer;
  //RectangleComponent onHit;
  EnemyManager() : super() {
    _timer = Timer(1, onTick: _spawnEnemy, repeat: true);
  }

  void _spawnEnemy() {
    Zombie zombie = Zombie();

    zombie.position =
        Vector2(Random().nextDouble() * 400, Random().nextDouble() * 1000);
    zombie.priority = 2;

    add(zombie);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }
}
