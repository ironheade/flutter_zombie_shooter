import 'package:flame/components.dart';

import 'package:flutter_zombie_shooter/enums_and_constants/mapComponents.dart';
import 'package:flutter_zombie_shooter/helpers/tree.dart';

class TreeManager extends Component with HasGameRef {
  void _spawnTree() async {
    for (var treeInfo in Trees) {
      Tree tree = Tree()
        ..sprite = await game.loadSprite(treeInfo["image"])
        ..anchor = treeInfo["anchor"]
        ..position = treeInfo["position"];
      add(tree);
    }
  }

  @override
  void onMount() {
    super.onMount();
    _spawnTree();
  }
}
