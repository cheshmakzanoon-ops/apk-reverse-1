local UISurfingBattleGuideFinish = {
  Name = UIWindowNames.UISurfingBattleGuideFinish,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurfing.Inside.GuideFinish.Controller.UISurfingBattleGuideFinishCtrl"),
  View = require("UI.UISurfing.Inside.GuideFinish.View.UISurfingBattleGuideFinishView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/Inside/UISurfingBattleGuideFinish.prefab"
}
return {UISurfingBattleGuideFinish = UISurfingBattleGuideFinish}
