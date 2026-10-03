local UIGhostParkourBattleCountDown = {
  Name = UIWindowNames.UIGhostParkourBattleCountDown,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Inside.CountDown.Controller.UIGhostParkourBattleCountDownCtrl"),
  View = require("UI.UIGhostParkour.Inside.CountDown.View.UIGhostParkourBattleCountDownView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/Inside/UIGhostParkourBattleCountDown.prefab"
}
return {UIGhostParkourBattleCountDown = UIGhostParkourBattleCountDown}
