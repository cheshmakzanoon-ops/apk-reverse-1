local UISurfingBattleGuide = {
  Name = UIWindowNames.UISurfingBattleGuide,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurfing.Inside.Guide.Controller.UISurfingBattleGuideCtrl"),
  View = require("UI.UISurfing.Inside.Guide.View.UISurfingBattleGuideView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/Inside/UISurfingBattleGuide.prefab"
}
return {UISurfingBattleGuide = UISurfingBattleGuide}
