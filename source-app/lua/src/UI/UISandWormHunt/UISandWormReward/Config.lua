local UISandWormReward = {
  Name = UIWindowNames.UISandWormReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISandWormHunt.UISandWormReward.Controller.UISandWormRewardCtrl"),
  View = require("UI.UISandWormHunt.UISandWormReward.View.UISandWormRewardView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/UISandWormHunt/UISandWormReward.prefab"
}
return {UISandWormReward = UISandWormReward}
