local UIBattleMessageBar = {
  Name = UIWindowNames.UIBattleMessageBar,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIGhostParkour.Inside.UIBattleMessageBar.Controller.UIBattleMessageBarCtrl"),
  View = require("UI.UIGhostParkour.Inside.UIBattleMessageBar.View.UIBattleMessageBarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/Inside/UIBattleMessageBar.prefab"
}
return {UIBattleMessageBar = UIBattleMessageBar}
