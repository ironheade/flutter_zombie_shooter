import 'package:flame/components.dart';
import 'package:flutter/animation.dart';

enum Weapon { rifle, shotgun, handgun, knife, flashlight }

enum Offsets { x, y }

//MS that pass before a bullet is fired
Map<Weapon, int> weaponDelaysMS = {
  Weapon.handgun: 400,
  Weapon.rifle: 50,
  Weapon.shotgun: 700,
  Weapon.flashlight: 10,
  Weapon.knife: 10
};

Map<Weapon, int> weaponReloadMS = {
  Weapon.handgun: 1000,
  Weapon.rifle: 1000,
  Weapon.shotgun: 1000,
};
Map<Weapon, int> magazineCapacity = {
  Weapon.handgun: 20,
  Weapon.rifle: 50,
  Weapon.shotgun: 5,
};
Map<Weapon, int> ammunitionCapacity = {
  Weapon.handgun: 100,
  Weapon.rifle: 250,
  Weapon.shotgun: 30,
};
//different animation speeds
Map<Weapon, double> weaponFireAnimationFactor = {
  Weapon.handgun: 5,
  Weapon.rifle: 1,
  Weapon.shotgun: 5,
  Weapon.flashlight: 1,
  Weapon.knife: 1
};

Map<Weapon, List<int>> scatterBullets = {
  Weapon.handgun: [0],
  Weapon.rifle: [0],
  Weapon.shotgun: [-6, -3, 0, 3, 6],
};

Map<Weapon, String> weaponBulletSprites = {
  Weapon.handgun: "handgunBullet.png",
  Weapon.rifle: "bullet.png",
  Weapon.shotgun: "bullet.png",
};

Map<Weapon, int> weaponBulletDamage = {
  Weapon.handgun: 100,
  Weapon.rifle: 25,
  Weapon.shotgun: 25,
};

Map<Weapon, Color> weaponBulletLight = {
  Weapon.handgun: Color.fromARGB(174, 255, 242, 182),
  Weapon.rifle: Color.fromARGB(172, 244, 25, 5),
  Weapon.shotgun: Color.fromARGB(172, 4, 8, 240),
};

Map<Weapon, Map<Offsets, num>> bulletOffset = {
  Weapon.handgun: {Offsets.x: 50, Offsets.y: 15},
  Weapon.rifle: {Offsets.x: 50, Offsets.y: 15},
  Weapon.shotgun: {Offsets.x: 50, Offsets.y: 15},
  Weapon.flashlight: {Offsets.x: 50, Offsets.y: 15},
  Weapon.knife: {Offsets.x: 50, Offsets.y: 15}
};

Map<Weapon, Vector2> bulletSize = {
  Weapon.rifle: Vector2(10, 5),
  Weapon.shotgun: Vector2(10, 5),
  Weapon.handgun: Vector2(10, 5),
};

Map<Weapon, int> lootBoxAdd = {
  Weapon.rifle: 50,
  Weapon.shotgun: 5,
  Weapon.handgun: 20,
};
