local UIDesertBattleCommanderSet = {
  Name = UIWindowNames.UIDesertBattleCommanderSet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleCommander.Controller.UIDesertBattleCommanderSetCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleCommander.View.UIDesertBattleCommanderSetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/BattleCommanderSet.prefab"
}
return {UIDesertBattleCommanderSet = UIDesertBattleCommanderSet}
