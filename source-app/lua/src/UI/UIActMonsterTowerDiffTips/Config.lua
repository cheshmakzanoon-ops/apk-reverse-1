local UIActMonsterTowerDiffTips = {
  Name = UIWindowNames.UIActMonsterTowerDiffTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonsterTowerDiffTips.Controller.UIActMonsterTowerDiffTipsCtrl"),
  View = require("UI.UIActMonsterTowerDiffTips.View.UIActMonsterTowerDiffTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterTower/UIActMonsterTowerDiffTips.prefab"
}
return {UIActMonsterTowerDiffTips = UIActMonsterTowerDiffTips}
