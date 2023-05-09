import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/main.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';
import 'package:rive/rive.dart';

class StartPage extends StatelessWidget {
  const StartPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.black),
        ),
        RiveAnimation.asset(
          'assets/images/zombie_background.riv',
          //'https://cdn.rive.app/animations/vehicles.riv',
          fit: BoxFit.contain,
        ),
        Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Zombie Shooter",
                      style: TextStyle(color: Colors.yellow, fontSize: 45),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        MainMenuButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewGame(game: ShooterGame())));
                          },
                          text: 'Start',
                        ),
                        MainMenuButton(onPressed: () {}, text: 'Options'),
                        MainMenuButton(onPressed: () {}, text: 'Levels'),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                "Konrad Bendzuck Games",
                style: TextStyle(color: Colors.yellow),
              )
            ],
          ),
        )
      ],
    );
  }
}

class MainMenuButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const MainMenuButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: ElevatedButton(
          style: kMainMenuButton,
          onPressed: onPressed,
          child: Text(
            text,
            style: kMainMenuButtonText,
          )),
    );
  }
}
