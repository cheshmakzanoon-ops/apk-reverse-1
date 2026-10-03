local TradeStationRecord = {
  Name = UIWindowNames.TradeStationHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonTradeStation.TradeStationHistory.TradeStationHistoryCtrl"),
  View = require("UI.LWSeason.LWSeasonTradeStation.TradeStationHistory.TradeStationHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/TradeStationHistory.prefab"
}
return {TradeStationRecord = TradeStationRecord}
