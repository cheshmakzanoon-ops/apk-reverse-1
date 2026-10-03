local LWUISeasonTowerRankReward = {
  Name = UIWindowNames.LWUISeasonTowerRankReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUISeasonTower.UISeasonTowerRankReward.Controller.UISeasonTowerRankRewardCtrl"),
  View = require("UI.LWUISeasonTower.UISeasonTowerRankReward.View.UISeasonTowerRankRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUISeasonTower/LWUISeasonTowerRankRewardView.prefab"
}
return {LWUISeasonTowerRankReward = LWUISeasonTowerRankReward}
