local UISurfingBattleResult = {
  Name = UIWindowNames.UISurfingBattleResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurfing.Inside.Result.Controller.UISurfingBattleResultCtrl"),
  View = require("UI.UISurfing.Inside.Result.View.UISurfingBattleResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/Inside/UISurfingBattleResult.prefab"
}
return {UISurfingBattleResult = UISurfingBattleResult}
