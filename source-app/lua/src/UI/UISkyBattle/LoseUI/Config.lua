local UISkyBattleLose = {
  Name = UIWindowNames.UISkyBattleLose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISkyBattle.LoseUI.Controller.UISkyBattleLoseCtrl"),
  View = require("UI.UISkyBattle.LoseUI.View.UISkyBattleLoseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SkyBattle/SkyBattleLosePanel.prefab"
}
return {UISkyBattleLose = UISkyBattleLose}
