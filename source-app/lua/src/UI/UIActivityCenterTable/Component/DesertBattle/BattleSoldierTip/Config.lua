local UIDesertBattleSoldierTip = {
  Name = UIWindowNames.UIDesertBattleSoldierTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleSoldierTip.Controller.UIDesertBattleSoldierTipCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleSoldierTip.View.UIDesertBattleSoldierTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/DesertBattleSoldierTip.prefab"
}
return {UIDesertBattleSoldierTip = UIDesertBattleSoldierTip}
