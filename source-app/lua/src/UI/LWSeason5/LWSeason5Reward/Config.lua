local LWSeason5Reward = {
  Name = UIWindowNames.UILWSeason5Reward,
  Layer = UILayer.Normal,
  Ctrl = require("UI/LWSeason5/LWSeason5Reward/Ctrl/LWSeason5RewardCtrl"),
  View = require("UI/LWSeason5/LWSeason5Reward/View/LWSeason5RewardView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/AllianceReward/S5SeasonReward.prefab",
  HideBack = true
}
return {LWSeasonReward = LWSeason5Reward}
