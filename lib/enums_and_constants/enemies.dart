import 'dart:math';

enum EnemyType {
  normal,
  bigHands,
  megaBoss,
}

enum EnemyAction {
  attack,
  walk,
  run,
  death,
}

class EnemyAnimation {
  late int columns;
  late String image;
  late double animationSpeed;
  late double scale;

  EnemyAnimation({
    required this.columns,
    required this.image,
    required this.animationSpeed,
    required this.scale,
  });
}

class EnemyDescription {
  late double shakeIntensity;
  late int healthPoints;
  late int damage;
  late double filter;
  late double extraRotation;

  late Map<EnemyAction, List<EnemyAnimation>> mapOfAnimation;

  EnemyDescription({
    this.shakeIntensity = 0,
    required this.healthPoints,
    required this.damage,
    required this.mapOfAnimation,
    required this.extraRotation,
  });
}

Map<EnemyType, EnemyDescription> enemies = {
  EnemyType.normal: EnemyDescription(
      healthPoints: 100,
      damage: 1,
      extraRotation: 0,
      mapOfAnimation: {
        EnemyAction.attack: [
          EnemyAnimation(
              columns: 9,
              image: "zombie-attack.png",
              animationSpeed: 1.8,
              scale: 1.3)
        ],
        EnemyAction.walk: [
          EnemyAnimation(
            columns: 17,
            image: "zombie-idle.png",
            animationSpeed: 1,
            scale: 1,
          )
        ],
        EnemyAction.run: [
          EnemyAnimation(
            columns: 17,
            image: "zombie-move.png",
            animationSpeed: 1,
            scale: 1.3,
          )
        ]
      }),
  EnemyType.bigHands: EnemyDescription(
    healthPoints: 400,
    damage: 1,
    mapOfAnimation: {
      EnemyAction.attack: [
        EnemyAnimation(
            columns: 9,
            image: "Zombie_big_hands_attack.png",
            animationSpeed: 2,
            scale: 2)
      ],
      EnemyAction.walk: [
        EnemyAnimation(
          columns: 9,
          image: "Zombie_big_hands_walk.png",
          animationSpeed: 2,
          scale: 1.3,
        )
      ],
      EnemyAction.run: [
        EnemyAnimation(
          columns: 9,
          image: "Zombie_big_hands_walk.png",
          animationSpeed: 2,
          scale: 1.3,
        )
      ]
    },
    extraRotation: -pi / 2,
  ),
  EnemyType.megaBoss: EnemyDescription(
    healthPoints: 400,
    damage: 1,
    mapOfAnimation: {
      EnemyAction.attack: [
        EnemyAnimation(
            columns: 16,
            image: "MegaBoss_attack1.png",
            animationSpeed: 2,
            scale: 2)
      ],
      EnemyAction.walk: [
        EnemyAnimation(
          columns: 8,
          image: "MegaBoss_Walk.png",
          animationSpeed: 4,
          scale: 1.8,
        )
      ],
      EnemyAction.run: [
        EnemyAnimation(
          columns: 8,
          image: "MegaBoss_Walk.png",
          animationSpeed: 2,
          scale: 1.8,
        )
      ]
    },
    extraRotation: -pi / 2,
  ),
};
