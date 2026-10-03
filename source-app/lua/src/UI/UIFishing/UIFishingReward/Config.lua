local UIFishingReward = {
  Name = UIWindowNames.UIFishingReward,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIFishing.UIFishingReward.UIFishingRewardCtrl"),
  View = require("UI.UIFishing.UIFishingReward.UIFishingRewardView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIFishingReward.prefab",
  AcquireHighFPSLockerForSeconds = 5,
  CustomKeyCodeEscape = true
}
return {UIFishingReward = UIFishingReward}
