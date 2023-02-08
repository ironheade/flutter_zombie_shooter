import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/helpers/directions.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_zombie_shooter/helpers/radialWeaponSelection.dart';
import 'package:flutter_zombie_shooter/helpers/weapons.dart';
import '../constants.dart';

class Navigation extends StatefulWidget {
  final ValueChanged<Direction>? onDirectionChanged;
  final ValueChanged<Weapon>? onWeaponChanged;

  const Navigation(
      {Key? key,
      required this.onDirectionChanged,
      required this.onWeaponChanged})
      : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  Direction direction = Direction(leftX: 0, leftY: 0, rightX: 0, rightY: 0);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * kControllerPaddingAsScreenWidthPercentage,
          vertical: screenHeight * kControllerPaddingAsScreenHeightPercentage),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          JoyStick(
            listener: ((details) {
              direction.leftX = details.x;
              direction.leftY = details.y;
              updateDirection(direction);
            }),
          ),
          RadialWeaponSelection(),
          /*
          GestureDetector(
            onTap: () => onWeaponChanged(Weapon.shotgun),
            child: Icon(
              Icons.switch_access_shortcut,
              size: 40,
            ),
          ),*/
          JoyStick(
            listener: ((details) {
              direction.rightX = details.x;
              direction.rightY = details.y;
              updateDirection(direction);
            }),
          ),
        ],
      ),
    );
  }

  void updateDirection(Direction newDirection) {
    direction = newDirection;
    widget.onDirectionChanged!(direction);
  }

  void onWeaponChanged(Weapon weapon) {
    print("tapped");
    widget.onWeaponChanged!(weapon);
  }
}

class JoyStick extends StatelessWidget {
  void Function(StickDragDetails) listener;

  JoyStick({super.key, required this.listener});

  @override
  Widget build(BuildContext context) {
    return Joystick(
      period: Duration(milliseconds: kContollerPeriodMS),
      listener: listener,
      /*
      stick: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [
              0.1,
              0.4,
              0.6,
              0.9,
            ],
            colors: [
              Colors.yellow,
              Colors.red,
              Colors.indigo,
              Colors.teal,
            ],
          ),
          shape: BoxShape.circle,
        ),
      ),*/
      base: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
