local S6MilitaryReward = {
  Name = UIWindowNames.S6MilitaryReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeasonMilitary.Reward.Ctrl.S6MilitaryRewardCtrl"),
  View = require("UI.LWSeason6.UILWSeasonMilitary.Reward.View.S6MilitaryRewardView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Military/S6MilitaryReward.prefab"
}
return {S6MilitaryReward = S6MilitaryReward}
