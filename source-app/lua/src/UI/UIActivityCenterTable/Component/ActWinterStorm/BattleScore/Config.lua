local UIWinterStormBattleScore = {
  Name = UIWindowNames.UIWinterStormBattleScore,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActWinterStorm.BattleScore.Controller.UIWinterStormBattleScoreCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActWinterStorm.BattleScore.View.UIWinterStormBattleScoreView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/UIWinterStormBattleScorePanel.prefab"
}
return {UIWinterStormBattleScore = UIWinterStormBattleScore}
