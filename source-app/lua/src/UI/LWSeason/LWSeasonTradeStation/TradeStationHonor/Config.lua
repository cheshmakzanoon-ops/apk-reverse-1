local TradeStationHonor = {
  Name = UIWindowNames.TradeStationHonor,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonTradeStation.TradeStationHonor.TradeStationHonorCtrl"),
  View = require("UI.LWSeason.LWSeasonTradeStation.TradeStationHonor.TradeStationHonorView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/TradeStationHonor.prefab"
}
return {TradeStationHonor = TradeStationHonor}
