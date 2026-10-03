local UIParkourBattleMain = {
  Name = UIWindowNames.UIParkourBattleMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIParkour.MainUI.Controller.UIParkourBattleMainCtrl"),
  View = require("UI.UIParkour.MainUI.View.UIParkourBattleMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/UIParkourBattleMain.prefab"
}
return {UIParkourBattleMain = UIParkourBattleMain}
