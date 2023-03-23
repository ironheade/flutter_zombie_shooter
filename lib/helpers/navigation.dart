import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/directions.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_zombie_shooter/helpers/radialWeaponSelection.dart';
import 'package:flutter_zombie_shooter/enums_and_constants/weapons.dart';
import '../enums_and_constants/constants.dart';

class Navigation extends StatefulWidget {
  final ValueChanged<Direction>? onDirectionChanged;
  final ValueChanged<Weapon>? onWeaponChanged;
  late ValueNotifier<Map<Weapon, int>> ammunition;
  late ValueNotifier<Map<Weapon, int>> magazine;

  Navigation(
      {Key? key,
      required this.onDirectionChanged,
      required this.onWeaponChanged,
      required this.ammunition,
      required this.magazine})
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
          RadialWeaponSelection(
              onWeaponChanged: onWeaponChanged,
              ammunition: widget.ammunition,
              magazine: widget.magazine),
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
    widget.onWeaponChanged!(weapon);
  }
}

class JoyStick extends StatelessWidget {
  void Function(StickDragDetails) listener;

  JoyStick({super.key, required this.listener});

  @override
  Widget build(BuildContext context) {
    return Joystick(
      period: Duration(milliseconds: kControllerPeriodMS),
      listener: listener,
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
