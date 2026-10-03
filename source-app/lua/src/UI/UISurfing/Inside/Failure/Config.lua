local UISurfingBattleFailure = {
  Name = UIWindowNames.UISurfingBattleFailure,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurfing.Inside.Failure.Controller.UISurfingBattleFailureCtrl"),
  View = require("UI.UISurfing.Inside.Failure.View.UISurfingBattleFailureView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/Inside/UISurfingBattleFailure.prefab"
}
return {UISurfingBattleFailure = UISurfingBattleFailure}
