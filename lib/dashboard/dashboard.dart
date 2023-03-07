import 'package:flame/components.dart';
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
                ValueListenableBuilder<int>(
                    valueListenable: widget.game.hp,
                    builder: (context, value, child) {
                      return Text(
                        "HP: ${widget.game.hp.value}",
                        style: TextStyle(
                            fontSize: 25, color: Colors.yellow.shade700),
                      );
                    }),
                ValueListenableBuilder<int>(
                  valueListenable: widget.game.kills,
                  builder: (context, value, child) {
                    return Text(
                      "Kills: ${widget.game.kills.value}",
                      style: TextStyle(
                          fontSize: 25, color: Colors.yellow.shade700),
                    );
                  },
                )
              ],
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    widget.game.paused = !widget.game.paused;
                  });
                },
                icon: Icon(widget.game.paused ? Icons.play_arrow : Icons.pause))
          ],
        ));
  }
}
