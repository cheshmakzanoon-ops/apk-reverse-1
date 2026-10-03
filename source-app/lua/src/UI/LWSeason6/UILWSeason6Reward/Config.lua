local UILWS6Reward = {
  Name = UIWindowNames.UILWS6Reward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.UILWSeason6Reward.Ctrl.LWS6RewardCtrl"),
  View = require("UI.LWSeason6.UILWSeason6Reward.View.LWS6RewardView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/AllianceReward/S6SeasonReward.prefab",
  HideBack = true
}
return {UILWS6Reward = UILWS6Reward}
