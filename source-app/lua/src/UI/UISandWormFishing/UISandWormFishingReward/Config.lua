local UISandWormFishingReward = {
  Name = UIWindowNames.UISandWormFishingReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISandWormFishing.UISandWormFishingReward.Controller.UISandWormFishingRewardCtrl"),
  View = require("UI.UISandWormFishing.UISandWormFishingReward.View.UISandWormFishingRewardView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/UISandWormFishing/UISandWormFishingReward.prefab",
  HideBack = true
}
return {UISandWormFishingReward = UISandWormFishingReward}
