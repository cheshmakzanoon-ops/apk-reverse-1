local LWUISeasonTowerReward = {
  Name = UIWindowNames.LWUISeasonTowerReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUISeasonTower.UISeasonTowerReward.Ctrl.LWUISeasonTowerRewardCtrl"),
  View = require("UI.LWUISeasonTower.UISeasonTowerReward.View.LWUISeasonTowerRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUISeasonTower/LWUISeasonTowerRewardView.prefab"
}
return {LWUISeasonTowerReward = LWUISeasonTowerReward}
