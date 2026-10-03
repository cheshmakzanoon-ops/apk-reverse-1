local UIDesertBattleHistory = {
  Name = UIWindowNames.UIDesertBattleHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleHistory.Controller.UIDesertBattleHistoryCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleHistory.View.UIDesertBattleHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/BattleHistory.prefab"
}
return {UIDesertBattleHistory = UIDesertBattleHistory}
