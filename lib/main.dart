import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_zombie_shooter/helpers/weapons.dart';
import 'shooter_game.dart';
import 'helpers/navigation.dart';

void main() {
  final game = ShooterGame();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(game: game),
            Align(
              alignment: Alignment.bottomCenter,
              child: Navigation(
                onDirectionChanged: game.onDirectionChanged,
                onWeaponChanged: game.onWeaponChanged,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
