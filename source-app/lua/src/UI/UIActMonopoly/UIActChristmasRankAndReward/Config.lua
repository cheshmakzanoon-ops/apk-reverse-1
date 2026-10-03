local UIActChristmasRankAndReward = {
  Name = UIWindowNames.UIActChristmasRankAndReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIActChristmasRankAndReward.Controller.UIActChristmasRankAndRewardCtrl"),
  View = require("UI.UIActMonopoly.UIActChristmasRankAndReward.View.UIActChristmasRankAndRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActChristmasRankAndRewardView.prefab"
}
return {UIActChristmasRankAndReward = UIActChristmasRankAndReward}
