local UIPuzzleMonsterRank = {
  Name = UIWindowNames.UIPuzzleMonsterRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPuzzleMonster.UIPuzzleMonsterRank.Controller.UIPuzzleMonsterRankCtrl"),
  View = require("UI.UIPuzzleMonster.UIPuzzleMonsterRank.View.UIPuzzleMonsterRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPuzzleMonster/UIPuzzleMonsterRank.prefab"
}
return {UIPuzzleMonsterRank = UIPuzzleMonsterRank}
