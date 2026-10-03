local SeasonFarmerBuildLevel = {
  Name = UIWindowNames.SeasonFarmerBuildLevel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.SeasonFarmerBuildLevel.Controller.SeasonFarmerBuildLevelCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.SeasonFarmerBuildLevel.View.SeasonFarmerBuildLevelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/SeasonFarmerBuildLevel.prefab"
}
return {SeasonFarmerBuildLevel = SeasonFarmerBuildLevel}
