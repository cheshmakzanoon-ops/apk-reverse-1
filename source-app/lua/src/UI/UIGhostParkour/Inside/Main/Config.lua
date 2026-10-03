local UIGhostParkourBattleMain = {
  Name = UIWindowNames.UIGhostParkourBattleMain,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIGhostParkour.Inside.Main.Controller.UIGhostParkourBattleMainCtrl"),
  View = require("UI.UIGhostParkour.Inside.Main.View.UIGhostParkourBattleMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/Inside/UIGhostParkourBattleMain.prefab"
}
return {UIGhostParkourBattleMain = UIGhostParkourBattleMain}
