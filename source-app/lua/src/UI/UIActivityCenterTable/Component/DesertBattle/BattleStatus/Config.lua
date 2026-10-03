local UIDesertBattleStatus = {
  Name = UIWindowNames.UIDesertBattleStatus,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleStatus.Controller.UIDesertBattleStatusCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleStatus.View.UIDesertBattleStatusView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/BattleStatus.prefab"
}
return {UIDesertBattleStatus = UIDesertBattleStatus}
