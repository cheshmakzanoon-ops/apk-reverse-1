local FarmerRewardCompare = {
  Name = UIWindowNames.FarmerRewardCompare,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.FarmerRewardCompare.Controller.FarmerRewardCompareCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.FarmerRewardCompare.View.FarmerRewardCompareView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/FarmerRewardCompareView.prefab"
}
return {FarmerRewardCompare = FarmerRewardCompare}
