local UIDesertBattleCommander = {
  Name = UIWindowNames.UIDesertBattleCommander,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleCommander.Controller.UIDesertBattleCommanderCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleCommander.View.UIDesertBattleCommanderView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/BattleCommander.prefab"
}
return {UIDesertBattleCommander = UIDesertBattleCommander}
