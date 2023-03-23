import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import 'dart:math';

import 'package:vector_math/vector_math.dart' show radians;

import '../enums_and_constants/constants.dart';

class RadialWeaponSelection extends StatefulWidget {
  final ValueChanged<Weapon>? onWeaponChanged;
  late ValueNotifier<Map<Weapon, int>> ammunition;
  late ValueNotifier<Map<Weapon, int>> magazine;

  RadialWeaponSelection(
      {Key? key,
      required this.onWeaponChanged,
      required this.ammunition,
      required this.magazine});

  @override
  State<RadialWeaponSelection> createState() => _RadialWeaponSelectionState();
}

class _RadialWeaponSelectionState extends State<RadialWeaponSelection>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  void onWeaponChanged(Weapon weapon) {
    widget.onWeaponChanged!(weapon);
  }

  void changeWeaponOnWheel(Weapon weapon) {
    setState(() {
      weapon = weapon;
    });
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Weapon weapon = Weapon.handgun;
    return RadialAnimation(
        magazine: widget.magazine,
        ammunition: widget.ammunition,
        controller: controller,
        onWeaponChanged: onWeaponChanged,
        changeWeaponOnWheel: changeWeaponOnWheel,
        weapon: weapon);
  }
}

// The Animation
class RadialAnimation extends StatelessWidget {
  late ValueNotifier<Map<Weapon, int>> magazine;
  late ValueNotifier<Map<Weapon, int>> ammunition;
  RadialAnimation(
      {super.key,
      required this.magazine,
      required this.ammunition,
      required this.controller,
      required this.onWeaponChanged,
      required this.weapon,
      required this.changeWeaponOnWheel})
      : scale = Tween<double>(
          begin: 1.5,
          end: 0.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        ),
        translation = Tween<double>(
          begin: 0.0,
          end: 80.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.linear),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3,
              0.9,
              curve: Curves.decelerate,
            ),
          ),
        );

  final ValueChanged<Weapon>? onWeaponChanged;
  final ValueChanged<Weapon>? changeWeaponOnWheel;
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translation;
  final Animation<double> rotation;
  final Weapon weapon;

  void switchWeaponTo(Weapon weapon) {
    changeWeaponOnWheel!(weapon);
    onWeaponChanged!(weapon);
    _close();
  }

  build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, builder) {
          return Transform.translate(
            offset: Offset(0, 75),
            child: Transform.rotate(
              angle: radians(rotation.value),
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
                BuildButton(
                    angle: 207,
                    image: "assets/images/knife.png",
                    loadStatus: 1,
                    onTap: () => switchWeaponTo(Weapon.knife),
                    translation: translation),
                ValueListenableBuilder(
                    valueListenable: magazine,
                    builder: (context, value, child) {
                      return BuildButton(
                          angle: 249,
                          image: "assets/images/gun_icon.png",
                          loadStatus: (ammunition.value[Weapon.handgun]! +
                                      magazine.value[Weapon.handgun]!)
                                  .toDouble() /
                              (ammunitionCapacity[Weapon.handgun]! +
                                  magazineCapacity[Weapon.handgun]!),
                          onTap: () => switchWeaponTo(Weapon.handgun),
                          translation: translation);
                    }),
                ValueListenableBuilder(
                    valueListenable: magazine,
                    builder: (context, value, child) {
                      return BuildButton(
                          angle: 291,
                          image: "assets/images/rifle.png",
                          loadStatus: (ammunition.value[Weapon.rifle]! +
                                      magazine.value[Weapon.rifle]!)
                                  .toDouble() /
                              (ammunitionCapacity[Weapon.rifle]! +
                                  magazineCapacity[Weapon.rifle]!),
                          onTap: () => switchWeaponTo(Weapon.rifle),
                          translation: translation);
                    }),
                ValueListenableBuilder(
                    valueListenable: magazine,
                    builder: (context, value, child) {
                      return BuildButton(
                          angle: 333,
                          image: "assets/images/shotgun.png",
                          loadStatus: (ammunition.value[Weapon.shotgun]! +
                                      magazine.value[Weapon.shotgun]!)
                                  .toDouble() /
                              (ammunitionCapacity[Weapon.shotgun]! +
                                  magazineCapacity[Weapon.shotgun]!),
                          onTap: () => switchWeaponTo(Weapon.shotgun),
                          translation: translation);
                    }),
                /*
                BuildButton(
                    angle: 249,
                    image: "assets/images/gun_icon.png",
                    loadStatus: 0.1,
                    onTap: () => switchWeaponTo(Weapon.handgun),
                    translation: translation),
                    
                BuildButton(
                    angle: 291,
                    image: "assets/images/rifle.png",
                    loadStatus: 0.6,
                    onTap: () => switchWeaponTo(Weapon.rifle),
                    translation: translation),
                    
                BuildButton(
                    angle: 333,
                    image: "assets/images/shotgun.png",
                    loadStatus: 0.5,
                    onTap: () => switchWeaponTo(Weapon.shotgun),
                    translation: translation),
                    */
                Transform.scale(
                    scale: scale.value -
                        1.5, // subtract the beginning value to run the opposite animation
                    child: centerButton(
                        onTap: _close,
                        image: "assets/images/weaponChange.png")),
                Transform.scale(
                  scale: scale.value,
                  child: centerButton(
                      onTap: _open, image: "assets/images/weaponChange.png"),
                )
              ]),
            ),
          );
        });
  }

  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
  }
}

class BuildButton extends StatelessWidget {
  final double angle;
  final String image;
  final double loadStatus;
  final VoidCallback onTap;
  final Animation<double> translation;
  final Color color;

  const BuildButton(
      {super.key,
      required this.angle,
      this.color = const Color.fromARGB(47, 129, 129, 129),
      required this.image,
      required this.loadStatus,
      required this.onTap,
      required this.translation});

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate((translation.value) * cos(radians(angle)),
            (translation.value) * sin(radians(angle))),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: kRadialWeaponOuterButtonSize,
          height: kRadialWeaponOuterButtonSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: kRadialWeaponOuterButtonSize,
                width: kRadialWeaponOuterButtonSize,
                child: CircularProgressIndicator(
                  value: loadStatus,
                  backgroundColor: Colors.redAccent,
                  valueColor: const AlwaysStoppedAnimation(Colors.green),
                  strokeWidth: 4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(image),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class centerButton extends StatelessWidget {
  final String image;
  final Color color;
  final VoidCallback onTap;

  const centerButton({
    required this.onTap,
    this.color = Colors.grey,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: ((details) => onTap),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kRadialWeaponCenterButtonSize),
        child: Container(
          padding: EdgeInsets.all(6),
          width: kRadialWeaponCenterButtonSize,
          height: kRadialWeaponCenterButtonSize,
          decoration: BoxDecoration(
            color: color,
          ),
          child: Image.asset(image),
        ),
      ),
    );
  }
}
