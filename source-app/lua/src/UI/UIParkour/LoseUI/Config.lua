local UIParkourBattleLose = {
  Name = UIWindowNames.UIParkourBattleLose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIParkour.LoseUI.Controller.UIParkourBattleLoseCtrl"),
  View = require("UI.UIParkour.LoseUI.View.UIParkourBattleLoseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourLosePanel.prefab"
}
return {UIParkourBattleLose = UIParkourBattleLose}
