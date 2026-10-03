local LWSeasonReward = {
  Name = UIWindowNames.UILWSeasonReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonReward.Controller.LWSeasonRewardCtrl"),
  View = require("UI.LWSeason.LWSeasonReward.View.LWSeasonRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonReward.prefab",
  HideBack = true
}
return {LWSeasonReward = LWSeasonReward}
