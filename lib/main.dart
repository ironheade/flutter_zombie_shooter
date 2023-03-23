import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_zombie_shooter/dashboard/dashboard.dart';
import 'shooter_game.dart';
import 'helpers/navigation.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);
  final game = ShooterGame();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
              overlayBuilderMap: {
                'Dashboard': (BuildContext context, ShooterGame game) {
                  return Dashboard(
                    game: game,
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Navigation(
                  onDirectionChanged: game.onDirectionChanged,
                  onWeaponChanged: game.onWeaponChanged,
                  ammunition: game.ammunition,
                  magazine: game.magazine),
            ),
          ],
        ),
      ),
    ),
  );
}
