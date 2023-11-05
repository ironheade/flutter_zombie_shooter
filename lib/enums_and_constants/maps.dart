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

class GameMap {
  String background;
  //List<ShapeHitbox> hitboxes;
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

        /*
        RectangleHitbox(
            size: Vector2(32.0, 300.0), 
            position: Vector2(199.131, 182.986))
          ..angle = 0.0500399 / 180 * pi,
        RectangleHitbox(
            size: Vector2(32.0, 519.804), 
            position: Vector2(286.262, 1446.0))
          ..angle = 0.0500399 / 180 * pi,
        RectangleHitbox(
            size: Vector2(32.0, 204.033), 
            position: Vector2(1024.45, 1427.0))
          ..angle = 0.0500399 / 180 * pi,
        RectangleHitbox(
            size: Vector2(32.0, 204.033), 
            position: Vector2(1016.18, 1762.0))
          ..angle = 0.0500399 / 180 * pi,
        RectangleHitbox(
            size: Vector2(32.0, 148.792), 
            position: Vector2(2418.13, 504.0))
          ..angle = 0.0500399 / 180 * pi,
        RectangleHitbox(
            size: Vector2(32.0, 114.448), 
            position: Vector2(2418.13, 268.0))
          ..angle = 0.0500399 / 180 * pi,
        RectangleHitbox(
            size: Vector2(441.76, 24.6142), 
            position: Vector2(231.262, 183.0))
          ..angle = 0.0500399 / 180 * pi,
        RectangleHitbox(
            size: Vector2(27.2475, 307.976), 
            position: Vector2(645.269, 183.0))
          ..angle = 0.0500399 / 180 * pi,
        RectangleHitbox(
            size: Vector2(186.568, 25.2356),
            position: Vector2(486.492, 466.019))
          ..angle = 0.0500399 / 180 * pi,
        RectangleHitbox(
            size: Vector2(173.837, 25.2356), 
            position: Vector2(199.022, 466.0))
          ..angle = 0.0500399 / 180 * pi,
        RectangleHitbox(
            size: Vector2(119.0, 191.0), 
            position: Vector2(941.326, 337.0))
          ..angle = 20.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(119.0, 191.0), 
            position: Vector2(1273.0, 557.332))
          ..angle = -9.83784 / 180 * pi,
        RectangleHitbox(
            size: Vector2(532.393, 24.0), 
            position: Vector2(965.357, 285.0))
          ..angle = 5.6349 / 180 * pi,
        RectangleHitbox(
            size: Vector2(28.0, 68.0), 
            position: Vector2(957.0, 86.0))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(28.0, 68.0), 
            position: Vector2(957.0, 241.0))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(25.2804, 222.274), 
            position: Vector2(1944.0, 466.1))
          ..angle = -11.6389 / 180 * pi,
        RectangleHitbox(
            size: Vector2(25.2804, 213.784), 
            position: Vector2(1989.9, 672.0))
          ..angle = 16.1687 / 180 * pi,
        RectangleHitbox(
            size: Vector2(25.2804, 187.159), 
            position: Vector2(1938.56, 867.0))
          ..angle = 42.5494 / 180 * pi,
        RectangleHitbox(
            size: Vector2(25.2804, 480.12), 
            position: Vector2(1828.34, 996.686))
          ..angle = 90.5592 / 180 * pi,
        RectangleHitbox(
            size: Vector2(25.2804, 480.12), 
            position: Vector2(1347.94, 982.538))
          ..angle = 100.263 / 180 * pi,
        RectangleHitbox(
            size: Vector2(25.2804, 765.04), 
            position: Vector2(829.908, 1114.55))
          ..angle = 89.032 / 180 * pi,
        RectangleHitbox(
            size: Vector2(25.2804, 765.04), 
            position: Vector2(1055.93, 1427.0))
          ..angle = 89.032 / 180 * pi,
        RectangleHitbox(
            size: Vector2(25.2804, 765.04), 
            position: Vector2(1040.93, 1941.0))
          ..angle = 89.032 / 180 * pi,
        RectangleHitbox(
            size: Vector2(25.2804, 86.9354), 
            position: Vector2(829.642, 1054.0))
          ..angle = 22.7668 / 180 * pi,
        RectangleHitbox(
            size: Vector2(25.2804, 51.9593), 
            position: Vector2(880.107, 894.0))
          ..angle = 22.7668 / 180 * pi,
        RectangleHitbox(
            size: Vector2(496.355, 24.0), 
            position: Vector2(1486.59, 337.0))
          ..angle = 13.4801 / 180 * pi,
        RectangleHitbox(
            size: Vector2(2634.0, 24.0), 
            position: Vector2(78.0, 65.0))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(2634.0, 24.0), 
            position: Vector2(78.0, 65.0))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(2634.0, 24.0), 
            position: Vector2(54.0, 2239.0))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(234.0, 24.0), 
            position: Vector2(2216.0, 268.0))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(128.0, 24.0), 
            position: Vector2(2322.0, 629.0))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(396.0, 24.0), 
            position: Vector2(2322.0, 884.0))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(279.0, 24.0), 
            position: Vector2(2321.0, 908.0))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(220.0, 24.0), 
            position: Vector2(2216.0, 285.0))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(2191.0, 24.0), 
            position: Vector2(2694.0, 2251.0))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(2191.0, 24.0), 
            position: Vector2(54.0, 2251.0))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(185.0, 226.0), 
            position: Vector2(1186.0, 1156.0))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(472.0, 156.0), 
            position: Vector2(1413.0, 2095.0))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(185.0, 226.0), 
            position: Vector2(1447.0, 1144.0))
          ..angle = 0.0 / 180 * pi,*/
      ]),
  GameMap(
      background: 'laboratory_map.png',
      decoratorColor: Color.fromARGB(182, 0, 0, 0),
      hitboxes: [
        MyHitbox(
            hitboxAngle: 0.0 / 180 * pi,
            hitboxPosition: Vector2(76.3114, 76.4),
            hitboxSize: Vector2(934.157, 16.3714)),
        MyHitbox(
          hitboxSize: Vector2(1599.91, 16.3714),
          hitboxPosition: Vector2(163.149, 1249.69),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(652.594, 16.3714),
          hitboxPosition: Vector2(321.034, 496.6),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(324.7, 15.7886),
          hitboxPosition: Vector2(76.3114, 406.557),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(586.643, 15.7886),
          hitboxPosition: Vector2(76.3114, 1165.1),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(171.9, 15.7886),
          hitboxPosition: Vector2(157.886, 586.643),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(109.143, 15.7886),
          hitboxPosition: Vector2(165.78, 1266.06),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(319.243, 15.7886),
          hitboxPosition: Vector2(634.174, 1249.69),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(136.429, 15.7886),
          hitboxPosition: Vector2(828.9, 1066.87),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(84.5857, 15.7886),
          hitboxPosition: Vector2(834.163, 1257.87),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(171.9, 15.7886),
          hitboxPosition: Vector2(828.9, 922.257),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(321.971, 15.7886),
          hitboxPosition: Vector2(978.891, 1080.51),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(226.471, 15.7886),
          hitboxPosition: Vector2(997.311, 750.357),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(70.9429, 15.7886),
          hitboxPosition: Vector2(963.103, 537.529),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(384.729, 15.7886),
          hitboxPosition: Vector2(997.311, 466.586),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(840.4, 15.7886),
          hitboxPosition: Vector2(1165.72, 922.257),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(237.386, 15.7886),
          hitboxPosition: Vector2(1165.72, 1257.87),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(237.386, 15.7886),
          hitboxPosition: Vector2(1494.65, 1257.87),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(237.386, 15.7886),
          hitboxPosition: Vector2(1502.55, 908.614),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(223.743, 15.7886),
          hitboxPosition: Vector2(1502.55, 578.457),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(766.729, 15.7886),
          hitboxPosition: Vector2(1752.53, 854.043),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(270.129, 15.7886),
          hitboxPosition: Vector2(1752.53, 1266.06),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(150.071, 15.7886),
          hitboxPosition: Vector2(1673.59, 995.929),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(81.8571, 15.7886),
          hitboxPosition: Vector2(1494.65, 158.257),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(237.386, 15.7886),
          hitboxPosition: Vector2(1420.97, 324.7),
          hitboxAngle: -90.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(97.3629, 16.3714),
          hitboxPosition: Vector2(76.3114, 406.557),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(271.037, 16.3714),
          hitboxPosition: Vector2(1165.72, 76.4),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(271.037, 16.3714),
          hitboxPosition: Vector2(1502.55, 76.4),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(160.517, 16.3714),
          hitboxPosition: Vector2(1165.72, 660.314),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(73.68, 16.3714),
          hitboxPosition: Vector2(1436.76, 663.043),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(499.971, 16.3714),
          hitboxPosition: Vector2(1173.62, 914.071),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(84.2057, 16.3714),
          hitboxPosition: Vector2(1173.62, 1004.11),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(157.886, 16.3714),
          hitboxPosition: Vector2(1352.55, 1004.11),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(89.4686, 16.3714),
          hitboxPosition: Vector2(1673.59, 987.743),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(147.36, 16.3714),
          hitboxPosition: Vector2(1615.7, 324.7),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(73.68, 16.3714),
          hitboxPosition: Vector2(1689.38, 586.643),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(47.3657, 16.3714),
          hitboxPosition: Vector2(963.103, 458.4),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(47.3657, 16.3714),
          hitboxPosition: Vector2(834.163, 750.357),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(47.3657, 16.3714),
          hitboxPosition: Vector2(963.103, 750.357),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(47.3657, 16.3714),
          hitboxPosition: Vector2(963.103, 521.157),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(210.514, 16.3714),
          hitboxPosition: Vector2(634.174, 922.257),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(86.8371, 16.3714),
          hitboxPosition: Vector2(1423.6, 150.071),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(92.1, 16.3714),
          hitboxPosition: Vector2(1502.55, 578.457),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(89.4686, 16.3714),
          hitboxPosition: Vector2(1673.59, 837.671),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(97.3629, 16.3714),
          hitboxPosition: Vector2(76.3114, 1156.91),
          hitboxAngle: 0.0 / 180 * pi,
        ),
        MyHitbox(
          hitboxSize: Vector2(97.3629, 16.3714),
          hitboxPosition: Vector2(76.3114, 578.457),
          hitboxAngle: 0.0 / 180 * pi,
        ), /*

        RectangleHitbox(
            size: Vector2(934.157, 16.3714), position: Vector2(76.3114, 76.4))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(1599.91, 16.3714),
            position: Vector2(163.149, 1249.69))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(652.594, 16.3714), position: Vector2(321.034, 496.6))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(324.7, 15.7886), position: Vector2(76.3114, 406.557))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(586.643, 15.7886), position: Vector2(76.3114, 1165.1))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(171.9, 15.7886), position: Vector2(157.886, 586.643))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(109.143, 15.7886), position: Vector2(165.78, 1266.06))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(319.243, 15.7886),
            position: Vector2(634.174, 1249.69))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(136.429, 15.7886), position: Vector2(828.9, 1066.87))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(84.5857, 15.7886),
            position: Vector2(834.163, 1257.87))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(171.9, 15.7886), position: Vector2(828.9, 922.257))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(321.971, 15.7886),
            position: Vector2(978.891, 1080.51))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(226.471, 15.7886),
            position: Vector2(997.311, 750.357))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(70.9429, 15.7886),
            position: Vector2(963.103, 537.529))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(384.729, 15.7886),
            position: Vector2(997.311, 466.586))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(840.4, 15.7886), position: Vector2(1165.72, 922.257))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(237.386, 15.7886),
            position: Vector2(1165.72, 1257.87))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(237.386, 15.7886),
            position: Vector2(1494.65, 1257.87))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(237.386, 15.7886),
            position: Vector2(1502.55, 908.614))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(223.743, 15.7886),
            position: Vector2(1502.55, 578.457))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(766.729, 15.7886),
            position: Vector2(1752.53, 854.043))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(270.129, 15.7886),
            position: Vector2(1752.53, 1266.06))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(150.071, 15.7886),
            position: Vector2(1673.59, 995.929))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(81.8571, 15.7886),
            position: Vector2(1494.65, 158.257))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(237.386, 15.7886), position: Vector2(1420.97, 324.7))
          ..angle = -90.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(97.3629, 16.3714),
            position: Vector2(76.3114, 406.557))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(271.037, 16.3714), position: Vector2(1165.72, 76.4))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(271.037, 16.3714), position: Vector2(1502.55, 76.4))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(160.517, 16.3714),
            position: Vector2(1165.72, 660.314))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(73.68, 16.3714), position: Vector2(1436.76, 663.043))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(499.971, 16.3714),
            position: Vector2(1173.62, 914.071))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(84.2057, 16.3714),
            position: Vector2(1173.62, 1004.11))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(157.886, 16.3714),
            position: Vector2(1352.55, 1004.11))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(89.4686, 16.3714),
            position: Vector2(1673.59, 987.743))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(147.36, 16.3714), position: Vector2(1615.7, 324.7))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(73.68, 16.3714), position: Vector2(1689.38, 586.643))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(47.3657, 16.3714), position: Vector2(963.103, 458.4))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(47.3657, 16.3714),
            position: Vector2(834.163, 750.357))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(47.3657, 16.3714),
            position: Vector2(963.103, 750.357))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(47.3657, 16.3714),
            position: Vector2(963.103, 521.157))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(210.514, 16.3714),
            position: Vector2(634.174, 922.257))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(86.8371, 16.3714), position: Vector2(1423.6, 150.071))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(92.1, 16.3714), position: Vector2(1502.55, 578.457))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(89.4686, 16.3714),
            position: Vector2(1673.59, 837.671))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(97.3629, 16.3714),
            position: Vector2(76.3114, 1156.91))
          ..angle = 0.0 / 180 * pi,
        RectangleHitbox(
            size: Vector2(97.3629, 16.3714),
            position: Vector2(76.3114, 578.457))
          ..angle = 0.0 / 180 * pi,*/
      ])
];
