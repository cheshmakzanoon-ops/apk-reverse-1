local UIParkourMysteryTreasureBattleWin = {
  Name = UIWindowNames.UIParkourMysteryTreasureBattleWin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIParkourMysteryTreasure.WinUI.Controller.UIParkourMysteryTreasureBattleWinCtrl"),
  View = require("UI.UIParkourMysteryTreasure.WinUI.View.UIParkourMysteryTreasureBattleWinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourMysteryTreasureWinPanel.prefab"
}
return {UIParkourMysteryTreasureBattleWin = UIParkourMysteryTreasureBattleWin}
