local S6MilitaryRewardTipsView = {
  Name = UIWindowNames.S6MilitaryRewardTipsView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonMilitary.RewardTips.Ctrl.S6MilitaryRewardTipsCtrl"),
  View = require("UI.LWSeason6.UILWSeasonMilitary.RewardTips.View.S6MilitaryRewardTipsView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Military/S6MilitaryRewardTips.prefab"
}
return {S6MilitaryRewardTipsView = S6MilitaryRewardTipsView}
