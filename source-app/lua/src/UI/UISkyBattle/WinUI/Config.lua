local UISkyBattleWin = {
  Name = UIWindowNames.UISkyBattleWin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISkyBattle.WinUI.Controller.UISkyBattleWinCtrl"),
  View = require("UI.UISkyBattle.WinUI.View.UISkyBattleWinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SkyBattle/SkyBattleWinPanel.prefab"
}
return {UISkyBattleWin = UISkyBattleWin}
