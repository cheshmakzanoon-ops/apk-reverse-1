local LWTradeStationBattleList = {
  Name = UIWindowNames.LWTradeStationBattleList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonTradeStation.LWTradeStationBattleList.Controller.LWTradeStationBattleListCtrl"),
  View = require("UI.LWSeason.LWSeasonTradeStation.LWTradeStationBattleList.View.LWTradeStationBattleListView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/TradeStation/LWTradeStationBattleList.prefab"
}
return {LWTradeStationBattleList = LWTradeStationBattleList}
