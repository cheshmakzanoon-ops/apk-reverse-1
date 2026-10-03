local LWTradeStationRecord = {
  Name = UIWindowNames.LWTradeStationRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonTradeStation.LWTradeStationRecord.Controller.LWTradeStationRecordCtrl"),
  View = require("UI.LWSeason.LWSeasonTradeStation.LWTradeStationRecord.View.LWTradeStationRecordView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/TradeStationRecordView.prefab"
}
return {LWTradeStationRecord = LWTradeStationRecord}
