import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_zombie_shooter/dashboard/dashboard.dart';
import 'package:flutter_zombie_shooter/mainMenu.dart';
import 'shooter_game.dart';
import 'helpers/navigation.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);
  //final game = ShooterGame();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: StartPage(),
        ),
        //
        //NewGame(game: ShooterGame()),
      ),
    ),
  );
}

class NewGame extends StatelessWidget {
  const NewGame({
    Key? key,
    required this.game,
  }) : super(key: key);

  final ShooterGame game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
