import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/shooter_game.dart';

class Dashboard extends StatefulWidget {
  late ShooterGame game;

  Dashboard({super.key, required this.game});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    //ValueListenableBuilder<int>(valueListenable: value,builder: (context,value),)

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HP:",
                  style: TextStyle(fontSize: 25, color: Colors.yellow.shade700),
                ),
                Text(
                  "Kills: ${widget.game.kills}",
                  style: TextStyle(fontSize: 25, color: Colors.yellow.shade700),
                )
              ],
            ),
            IconButton(
                onPressed: () {
                  widget.game.pauseGame();
                },
                icon: Icon(widget.game.paused ? Icons.play_arrow : Icons.pause))
          ],
        ));
  }
}
