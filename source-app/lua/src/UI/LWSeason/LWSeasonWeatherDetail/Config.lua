local TradeStationTitle = {
  Name = UIWindowNames.UILWSeasonWeatherDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonWeatherDetail.SeasonWeatherDetailCtrl"),
  View = require("UI.LWSeason.LWSeasonWeatherDetail.SeasonWeatherDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/SeasonWeatherDetail.prefab"
}
return {TradeStationTitle = TradeStationTitle}
