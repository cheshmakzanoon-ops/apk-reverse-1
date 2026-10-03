local UIActMonsterTowerReward = {
  Name = UIWindowNames.UIActMonsterTowerReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonsterTowerReward.Controller.UIActMonsterTowerRewardCtrl"),
  View = require("UI.UIActMonsterTowerReward.View.UIActMonsterTowerRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterTower/UIActMonsterTowerReward.prefab"
}
return {UIActMonsterTowerReward = UIActMonsterTowerReward}
