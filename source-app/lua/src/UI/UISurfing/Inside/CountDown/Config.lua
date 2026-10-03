local UISurfingBattleCountDown = {
  Name = UIWindowNames.UISurfingBattleCountDown,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurfing.Inside.CountDown.Controller.UISurfingBattleCountDownCtrl"),
  View = require("UI.UISurfing.Inside.CountDown.View.UISurfingBattleCountDownView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/Inside/UISurfingBattleCountDown.prefab"
}
return {UISurfingBattleCountDown = UISurfingBattleCountDown}
