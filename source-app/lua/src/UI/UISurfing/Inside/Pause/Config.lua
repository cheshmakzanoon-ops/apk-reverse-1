local UISurfingBattlePause = {
  Name = UIWindowNames.UISurfingBattlePause,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurfing.Inside.Pause.Controller.UISurfingBattlePauseCtrl"),
  View = require("UI.UISurfing.Inside.Pause.View.UISurfingBattlePauseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/Inside/UISurfingBattlePause.prefab"
}
return {UISurfingBattlePause = UISurfingBattlePause}
