import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter_zombie_shooter/enemy.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/enemies.dart';
import 'package:flutter_zombie_shooter/player.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';

import '../enums_and_constants/constants.dart';

class EnemyManager extends Component
    with CollisionCallbacks, HasGameRef<ShooterGame> {
  late Timer _timer;
  late Player player;

  //RectangleComponent onHit;
  EnemyManager({required this.player}) : super() {
    _timer = Timer(2, onTick: _spawnEnemy, repeat: true);
  }
  int i = 0;
  void _spawnEnemy() {
    i++;
    Zombie zombie;
    if (i % 4 == 0) {
      zombie = Zombie(
        player: player,
        zombieFilter: Color.fromARGB(107, 95, 19, 7),
        //zombieSpeedFactor: 2,
        enemyType: EnemyType.bigHands,
      );
    } else if (i % 11 == 0) {
      zombie = Zombie(
        player: player,
        zombieFilter: Color.fromARGB(107, 95, 19, 7),
        //zombieSpeedFactor: 2,
        enemyType: EnemyType.megaBoss,
      );
    } else if (i % 10 == 0) {
      zombie = Zombie(
        player: player,
        zombieFilter: Color.fromARGB(107, 170, 30, 8),
        zombieSpeedFactor: 2,
        enemyType: EnemyType.normal,
      );
    } else {
      zombie = Zombie(
        player: player,
        //zombieFilter: Color.fromARGB(107, 151, 29, 10),
        //zombieSpeedFactor: 2,
        enemyType: EnemyType.normal,
      );
    }
/*
    Zombie zombie = i % 2 == 0
        ? Zombie(
            player: player,
            //zombieFilter: Color.fromARGB(107, 151, 29, 10),
            //zombieSpeedFactor: 2,
            enemyType: EnemyType.normal,
          )
        : Zombie(
            player: player,
            zombieFilter: Color.fromARGB(107, 95, 19, 7),
            //zombieSpeedFactor: 2,
            enemyType: EnemyType.megaBoss,
          );
          */

    zombie
      ..position = Vector2(400 + Random().nextDouble() * 400, 1250)
      ..priority = 2;
    gameRef.enemyList.add(zombie);
    parent!.add(zombie);
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
    if (gameRef.hp.value < 1) {
      _timer.stop();
      Future.delayed(
          Duration(milliseconds: (kBlackoutTimeDelay * 1000).toInt()), () {
        removeFromParent();
      });
    }
  }
}
