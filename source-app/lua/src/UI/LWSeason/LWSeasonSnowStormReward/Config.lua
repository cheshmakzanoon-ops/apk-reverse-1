local UIActSnowStormReward = {
  Name = UIWindowNames.UIActSnowStormReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonSnowStormReward.Controller.UIActSnowStormRewardCtrl"),
  View = require("UI.LWSeason.LWSeasonSnowStormReward.View.UIActSnowStormRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/SnowStormComing/UIActSnowStormRewardView.prefab"
}
return {UIActSnowStormReward = UIActSnowStormReward}
