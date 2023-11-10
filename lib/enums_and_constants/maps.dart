import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_zombie_shooter/helpers/playerLight.dart';
import 'package:flutter_zombie_shooter/helpers/streetLamp.dart';

class MyHitbox {
  Vector2 hitboxPosition;
  Vector2 hitboxSize;
  double hitboxAngle;

  MyHitbox(
      {required this.hitboxAngle,
      required this.hitboxPosition,
      required this.hitboxSize});
}

class MyObstacleRound {
  Vector2 hitboxPosition;
  double hitboxRadius;

  MyObstacleRound({
    required this.hitboxPosition,
    required this.hitboxRadius,
  });
}

class GameMap {
  String background;
  //List<ShapeHitbox> hitboxes;
  List<MyObstacleRound> obstaclesRound;
  List<MyHitbox> hitboxes;
  Color decoratorColor;
  List<PlayerLight> lightSources;
  List<PositionComponent> additionalComponents;
  /*
  enemy spawn
  player spawn
   */

  GameMap(
      {required this.background,
      this.hitboxes = const [],
      this.obstaclesRound = const [],
      this.lightSources = const [],
      this.additionalComponents = const [],
      this.decoratorColor = const Color.fromARGB(220, 0, 0, 0)});
}

List<GameMap> maps = [
  GameMap(
    background: 'map.png',
    additionalComponents: [
      StreetLamp(streetLampPosition: Vector2.all(20)),
      StreetLamp(streetLampPosition: Vector2(574, 1265)),
      StreetLamp(streetLampPosition: Vector2(903, 1097)),
      StreetLamp(streetLampPosition: Vector2(705, 829)),
      StreetLamp(streetLampPosition: Vector2(1003, 507)),
      StreetLamp(streetLampPosition: Vector2(751, 420)),
      StreetLamp(streetLampPosition: Vector2(836, 118)),
      StreetLamp(streetLampPosition: Vector2(1092, 199)),
    ],
  ),
  GameMap(
      background: 'testmap.png',
      decoratorColor: Color.fromARGB(0, 0, 0, 0),
      hitboxes: [
        MyHitbox(
          hitboxSize: Vector2(32.0, 300.0),
          hitboxPosition: Vector2(199.131, 182.986),
          hitboxAngle: 0.0500399 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(32.0, 519.804),
          hitboxPosition: Vector2(286.262, 1446.0),
          hitboxAngle: 0.0500399 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(32.0, 204.033),
          hitboxPosition: Vector2(1024.45, 1427.0),
          hitboxAngle: 0.0500399 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(32.0, 204.033),
          hitboxPosition: Vector2(1016.18, 1762.0),
          hitboxAngle: 0.0500399 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(32.0, 148.792),
          hitboxPosition: Vector2(2418.13, 504.0),
          hitboxAngle: 0.0500399 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(32.0, 114.448),
          hitboxPosition: Vector2(2418.13, 268.0),
          hitboxAngle: 0.0500399 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(441.76, 24.6142),
          hitboxPosition: Vector2(231.262, 183.0),
          hitboxAngle: 0.0500399 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(27.2475, 307.976),
          hitboxPosition: Vector2(645.269, 183.0),
          hitboxAngle: 0.0500399 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(186.568, 25.2356),
          hitboxPosition: Vector2(486.492, 466.019),
          hitboxAngle: 0.0500399 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(173.837, 25.2356),
          hitboxPosition: Vector2(199.022, 466.0),
          hitboxAngle: 0.0500399 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(119.0, 191.0),
          hitboxPosition: Vector2(941.326, 337.0),
          hitboxAngle: 20.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(119.0, 191.0),
          hitboxPosition: Vector2(1273.0, 557.332),
          hitboxAngle: -9.83784 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(532.393, 24.0),
          hitboxPosition: Vector2(965.357, 285.0),
          hitboxAngle: 5.6349 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(28.0, 68.0),
          hitboxPosition: Vector2(957.0, 86.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(28.0, 68.0),
          hitboxPosition: Vector2(957.0, 241.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(25.2804, 222.274),
          hitboxPosition: Vector2(1944.0, 466.1),
          hitboxAngle: -11.6389 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(25.2804, 213.784),
          hitboxPosition: Vector2(1989.9, 672.0),
          hitboxAngle: 16.1687 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(25.2804, 187.159),
          hitboxPosition: Vector2(1938.56, 867.0),
          hitboxAngle: 42.5494 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(25.2804, 480.12),
          hitboxPosition: Vector2(1828.34, 996.686),
          hitboxAngle: 90.5592 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(25.2804, 480.12),
          hitboxPosition: Vector2(1347.94, 982.538),
          hitboxAngle: 100.263 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(25.2804, 765.04),
          hitboxPosition: Vector2(829.908, 1114.55),
          hitboxAngle: 89.032 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(25.2804, 765.04),
          hitboxPosition: Vector2(1055.93, 1427.0),
          hitboxAngle: 89.032 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(25.2804, 765.04),
          hitboxPosition: Vector2(1040.93, 1941.0),
          hitboxAngle: 89.032 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(25.2804, 86.9354),
          hitboxPosition: Vector2(829.642, 1054.0),
          hitboxAngle: 22.7668 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(25.2804, 51.9593),
          hitboxPosition: Vector2(880.107, 894.0),
          hitboxAngle: 22.7668 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(496.355, 24.0),
          hitboxPosition: Vector2(1486.59, 337.0),
          hitboxAngle: 13.4801 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(2634.0, 24.0),
          hitboxPosition: Vector2(78.0, 65.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(2634.0, 24.0),
          hitboxPosition: Vector2(78.0, 65.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(2634.0, 24.0),
          hitboxPosition: Vector2(54.0, 2239.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(234.0, 24.0),
          hitboxPosition: Vector2(2216.0, 268.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(128.0, 24.0),
          hitboxPosition: Vector2(2322.0, 629.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(396.0, 24.0),
          hitboxPosition: Vector2(2322.0, 884.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(279.0, 24.0),
          hitboxPosition: Vector2(2321.0, 908.0),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(220.0, 24.0),
          hitboxPosition: Vector2(2216.0, 285.0),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(2191.0, 24.0),
          hitboxPosition: Vector2(2694.0, 2251.0),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(2191.0, 24.0),
          hitboxPosition: Vector2(54.0, 2251.0),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(185.0, 226.0),
          hitboxPosition: Vector2(1186.0, 1156.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(472.0, 156.0),
          hitboxPosition: Vector2(1413.0, 2095.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(185.0, 226.0),
          hitboxPosition: Vector2(1447.0, 1144.0),
          hitboxAngle: 0.0 / 180 * pi,
        ),
      ]),
  GameMap(
      background: 'laboratory_map.png',
      decoratorColor: Color.fromARGB(182, 0, 0, 0),
      obstaclesRound: [
        MyObstacleRound(hitboxPosition: Vector2(409, 361), hitboxRadius: 25),
        MyObstacleRound(hitboxPosition: Vector2(823, 396), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(886, 348), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(807, 319), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(711, 319), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(622, 319), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(540, 326), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(1023, 558), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(851, 582), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(772, 547), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(684, 552), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(605, 582), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(535, 552), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(433, 582), hitboxRadius: 35),
        MyObstacleRound(hitboxPosition: Vector2(474, 437), hitboxRadius: 35),
      ],
      hitboxes: [
        MyHitbox(
            hitboxSize: Vector2(1226.0, 21.0),
            hitboxPosition: Vector2(36.0, 99.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(2091.0, 21.0),
            hitboxPosition: Vector2(149.0, 1571.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(851.0, 21.0),
            hitboxPosition: Vector2(362.0, 625.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(433.0, 20.0),
            hitboxPosition: Vector2(36.0, 532.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(749.0, 20.0),
            hitboxPosition: Vector2(36.0, 1476.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(237.0, 19.0),
            hitboxPosition: Vector2(151.0, 748.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(137.224, 19.5771),
            hitboxPosition: Vector2(149.0, 1592.22),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(432.0, 20.0),
            hitboxPosition: Vector2(766.0, 1592.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(428.0, 20.0),
            hitboxPosition: Vector2(1027.0, 1371.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(123.0, 20.0),
            hitboxPosition: Vector2(1028.0, 1592.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(428.0, 20.0),
            hitboxPosition: Vector2(1214.0, 1371.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(309.0, 20.0),
            hitboxPosition: Vector2(1242.0, 964.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(100.0, 20.0),
            hitboxPosition: Vector2(1194.0, 676.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(498.0, 20.0),
            hitboxPosition: Vector2(1242.0, 597.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(430.0, 20.0),
            hitboxPosition: Vector2(1469.0, 1163.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(430.0, 20.0),
            hitboxPosition: Vector2(1463.0, 526.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(335.0, 20.0),
            hitboxPosition: Vector2(1463.0, 1592.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(335.0, 20.0),
            hitboxPosition: Vector2(1890.0, 1592.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(236.0, 13.0),
            hitboxPosition: Vector2(1687.0, 1592.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(236.0, 13.0),
            hitboxPosition: Vector2(2124.0, 1592.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(236.0, 13.0),
            hitboxPosition: Vector2(2007.0, 1592.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(236.0, 13.0),
            hitboxPosition: Vector2(1790.0, 1592.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(760.0, 20.0),
            hitboxPosition: Vector2(1900.0, 1163.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(972.0, 20.0),
            hitboxPosition: Vector2(2225.0, 1074.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(346.0, 20.0),
            hitboxPosition: Vector2(2220.0, 1592.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(214.0, 20.0),
            hitboxPosition: Vector2(2121.0, 1267.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(115.0, 20.0),
            hitboxPosition: Vector2(1896.0, 215.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(324.0, 20.0),
            hitboxPosition: Vector2(1799.0, 420.0),
            hitboxAngle: -90.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(134.0, 21.0),
            hitboxPosition: Vector2(36.0, 511.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(356.0, 21.0),
            hitboxPosition: Vector2(1463.0, 96.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(349.0, 21.0),
            hitboxPosition: Vector2(1896.0, 100.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(224.0, 21.0),
            hitboxPosition: Vector2(1469.0, 830.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(128.0, 21.0),
            hitboxPosition: Vector2(1792.0, 831.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(668.0, 21.0),
            hitboxPosition: Vector2(1469.0, 1142.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(122.0, 21.0),
            hitboxPosition: Vector2(1463.0, 1257.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(122.0, 21.0),
            hitboxPosition: Vector2(1463.0, 1356.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(232.0, 21.0),
            hitboxPosition: Vector2(1678.0, 1257.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(225.0, 21.0),
            hitboxPosition: Vector2(2014.0, 1246.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(219.0, 21.0),
            hitboxPosition: Vector2(2026.0, 403.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(122.0, 21.0),
            hitboxPosition: Vector2(2123.0, 733.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(68.0, 21.0),
            hitboxPosition: Vector2(1194.0, 576.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(66.0, 21.0),
            hitboxPosition: Vector2(1027.0, 943.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(68.0, 21.0),
            hitboxPosition: Vector2(1194.0, 943.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(68.0, 21.0),
            hitboxPosition: Vector2(1194.0, 655.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(281.0, 20.0),
            hitboxPosition: Vector2(766.0, 1160.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(117.0, 21.0),
            hitboxPosition: Vector2(1799.0, 194.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(126.0, 21.0),
            hitboxPosition: Vector2(1900.0, 733.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(124.0, 21.0),
            hitboxPosition: Vector2(2121.0, 1053.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(133.0, 21.0),
            hitboxPosition: Vector2(36.0, 1455.0),
            hitboxAngle: 0.0 / 180 * pi),
        MyHitbox(
            hitboxSize: Vector2(134.0, 21.0),
            hitboxPosition: Vector2(36.0, 727.0),
            hitboxAngle: 0.0 / 180 * pi),
      ])
];
