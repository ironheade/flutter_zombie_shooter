import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/constants.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                    valueListenable: widget.game.hp,
                    builder: (context, value, child) {
                      return Text(
                        widget.game.hp.value > 0
                            ? "HP: ${widget.game.hp.value}"
                            : "HP: 0",
                        style: TextStyle(
                            fontSize: 25, color: Colors.yellow.shade700),
                      );
                    }),
                ValueListenableBuilder<int>(
                  valueListenable: widget.game.kills,
                  builder: (context, value, child) {
                    return Text(
                      "Kills: ${widget.game.kills.value}",
                      style: kDashBoardFont,
                    );
                  },
                ),
                Row(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: widget.game.ammunition,
                        builder: (context, value, child) {
                          return widget.game.currentWeapon != Weapon.knife
                              ? Text(
                                  "${widget.game.ammunition.value[widget.game.currentWeapon]!.toString()}/",
                                  style: kDashBoardFont,
                                )
                              : Text("");
                        }),
                    ValueListenableBuilder(
                        valueListenable: widget.game.magazine,
                        builder: (context, value, child) {
                          return widget.game.currentWeapon != Weapon.knife
                              ? Text(
                                  widget.game.magazine
                                      .value[widget.game.currentWeapon]!
                                      .toString(),
                                  style: kDashBoardFont,
                                )
                              : Text("");
                        }),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: widget.game.hp,
                  builder: (context, value, child) {
                    return widget.game.hp.value < 1
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              widget.game.ResetGame();
                            },
                            icon: Icon(
                              Icons.refresh_sharp,
                              color: Colors.yellow.shade700,
                            ),
                            iconSize: 110,
                          )
                        : Text("");
                  },
                ),
              ],
            ),
            Column(children: [
              IconButton(
                  onPressed: () {
                    widget.game.hp.value < 1
                        ? widget.game.ResetGame()
                        : setState(() {
                            widget.game.paused = !widget.game.paused;
                          });
                  },
                  icon:
                      Icon(widget.game.paused ? Icons.play_arrow : Icons.pause))
            ]),
          ],
        ));
  }
}
