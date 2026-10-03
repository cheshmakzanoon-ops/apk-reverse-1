local TradeStationTitle = {
  Name = UIWindowNames.TradeStationTitle,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonTradeStation.TradeStationTitle.TradeStationTitleCtrl"),
  View = require("UI.LWSeason.LWSeasonTradeStation.TradeStationTitle.TradeStationTitleView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/TradeStationTitle.prefab"
}
return {TradeStationTitle = TradeStationTitle}
