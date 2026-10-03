local UIParkourBattleWin = {
  Name = UIWindowNames.UIParkourBattleWin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIParkour.WinUI.Controller.UIParkourBattleWinCtrl"),
  View = require("UI.UIParkour.WinUI.View.UIParkourBattleWinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourWinPanel.prefab"
}
return {UIParkourBattleWin = UIParkourBattleWin}
