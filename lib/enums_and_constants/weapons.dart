import 'package:flame/components.dart';

enum Weapon { rifle, shotgun, handgun, knife, flashlight }

enum Offsets { x, y }

Map<Weapon, num> weaponDelaysMS = {
  Weapon.handgun: 80,
  Weapon.rifle: 20,
  Weapon.shotgun: 110,
  Weapon.flashlight: 10,
  Weapon.knife: 10
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

Map<Weapon, Map<Offsets, num>> bulletOffset = {
  Weapon.handgun: {Offsets.x: 50, Offsets.y: 15},
  Weapon.rifle: {Offsets.x: 50, Offsets.y: 15},
  Weapon.shotgun: {Offsets.x: 50, Offsets.y: 15},
  Weapon.flashlight: {Offsets.x: 50, Offsets.y: 15},
  Weapon.knife: {Offsets.x: 50, Offsets.y: 15}
};

Map<Weapon, Vector2> bulletSize = {
  Weapon.handgun: Vector2(10, 5),
  Weapon.rifle: Vector2(10, 5),
  Weapon.shotgun: Vector2(10, 5),
};
