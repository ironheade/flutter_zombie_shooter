import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

double kControllerPaddingAsScreenWidthPercentage = 0.1;
double kControllerPaddingAsScreenHeightPercentage = 0.1;

int kControllerPeriodMS = 10;

double kPlayerSize = 100;
double kPlayerAnimationSpeed = 0.05;
double kPlayerSpeedFactor = 0.5;
int kPlayerHealthPoints = 100;

double kRadialWeaponCenterButtonSize = 40;
double kRadialWeaponOuterButtonSize = 50;

double kZombieSize = 100;
double kZombieAnimationSpeed = 0.05;
double kZombieSpeed = 25;
int kZombieHealthpoints = 100;

double kBlackoutTimeDelay = 4.75;

TextStyle kDashBoardFont =
    TextStyle(fontSize: 25, color: Colors.yellow.shade700);

TextStyle kMainMenuButtonText = TextStyle(color: Colors.black, fontSize: 32);

ButtonStyle kMainMenuButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.yellow,
    shadowColor: Colors.yellowAccent,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    minimumSize: Size(200, 10));
