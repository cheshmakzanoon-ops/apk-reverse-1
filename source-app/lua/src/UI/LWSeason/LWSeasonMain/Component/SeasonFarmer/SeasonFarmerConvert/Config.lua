local SeasonFarmerConvert = {
  Name = UIWindowNames.SeasonFarmerConvert,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.SeasonFarmerConvert.Controller.SeasonFarmerConvertCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.SeasonFarmerConvert.View.SeasonFarmerConvertView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/SeasonFarmerConvert.prefab"
}
return {SeasonFarmerConvert = SeasonFarmerConvert}
