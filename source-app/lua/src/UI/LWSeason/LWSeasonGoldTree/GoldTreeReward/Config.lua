local GoldTreeReward = {
  Name = UIWindowNames.GoldTreeReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeReward.GoldTreeRewardCtrl"),
  View = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeReward.GoldTreeRewardView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTree/GoldTreeReward.prefab"
}
return {GoldTreeReward = GoldTreeReward}
