local UIActMonsterTowerRank = {
  Name = UIWindowNames.UIActMonsterTowerRank,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIActMonsterTowerRank.Controller.UIActMonsterTowerRankCtrl"),
  View = require("UI.UIActMonsterTowerRank.View.UIActMonsterTowerRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterTower/UIActMonsterTowerRank.prefab"
}
return {UIActMonsterTowerRank = UIActMonsterTowerRank}
