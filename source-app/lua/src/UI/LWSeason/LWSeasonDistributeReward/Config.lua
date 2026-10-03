local LWSeasonDistributeReward = {
  Name = UIWindowNames.UILWSeasonDistributeReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonDistributeReward.Controller.UILWSeasonDistributeRewardCtrl"),
  View = require("UI.LWSeason.LWSeasonDistributeReward.View.UILWSeasonDistributeRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/UISeasonDistributeReward.prefab"
}
return {LWSeasonDistributeReward = LWSeasonDistributeReward}
