local UIParkourMysteryTreasureBattleLose = {
  Name = UIWindowNames.UIParkourMysteryTreasureBattleLose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIParkourMysteryTreasure.LoseUI.Controller.UIParkourMysteryTreasureBattleLoseCtrl"),
  View = require("UI.UIParkourMysteryTreasure.LoseUI.View.UIParkourMysteryTreasureBattleLoseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourMysteryTreasureLosePanel.prefab"
}
return {UIParkourMysteryTreasureBattleLose = UIParkourMysteryTreasureBattleLose}
