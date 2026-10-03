local UIPuzzleMonsterList = {
  Name = UIWindowNames.UIPuzzleMonsterList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPuzzleMonster.UIPuzzleMonsterList.Controller.UIPuzzleMonsterListCtrl"),
  View = require("UI.UIPuzzleMonster.UIPuzzleMonsterList.View.UIPuzzleMonsterListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPuzzleMonster/UIPuzzleMonsterList.prefab"
}
return {UIPuzzleMonsterList = UIPuzzleMonsterList}
