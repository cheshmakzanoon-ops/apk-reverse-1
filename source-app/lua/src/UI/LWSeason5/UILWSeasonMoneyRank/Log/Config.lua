local SeasonMoneyRankLog = {
  Name = UIWindowNames.SeasonMoneyRankLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UILWSeasonMoneyRank.Log.Ctrl.SeasonMoneyRankLogCtrl"),
  View = require("UI.LWSeason5.UILWSeasonMoneyRank.Log.View.SeasonMoneyRankLogView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/SeasonMoneyRank/SeasonMoneyRankLogView.prefab"
}
return {SeasonMoneyRankLog = SeasonMoneyRankLog}
