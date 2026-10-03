local TradeStationCity = {
  Name = UIWindowNames.TradeStationCity,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonTradeStation.TradeStationCity.TradeStationCityCtrl"),
  View = require("UI.LWSeason.LWSeasonTradeStation.TradeStationCity.TradeStationCityView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/TradeStationCity.prefab"
}
return {TradeStationCity = TradeStationCity}
