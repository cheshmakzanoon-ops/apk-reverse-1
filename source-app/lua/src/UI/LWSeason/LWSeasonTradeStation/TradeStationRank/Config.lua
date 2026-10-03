local TradeStationRank = {
  Name = UIWindowNames.TradeStationRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonTradeStation.TradeStationRank.TradeStationRankCtrl"),
  View = require("UI.LWSeason.LWSeasonTradeStation.TradeStationRank.TradeStationRankView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/TradeStationRank.prefab"
}
return {TradeStationRank = TradeStationRank}
