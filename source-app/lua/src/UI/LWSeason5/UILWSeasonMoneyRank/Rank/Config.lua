local SeasonMoneyRankRank = {
  Name = UIWindowNames.SeasonMoneyRankRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UILWSeasonMoneyRank.Rank.Ctrl.SeasonMoneyRankRankCtrl"),
  View = require("UI.LWSeason5.UILWSeasonMoneyRank.Rank.View.SeasonMoneyRankRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/SeasonMoneyRank/SeasonMoneyRankRank.prefab"
}
return {SeasonMoneyRankRank = SeasonMoneyRankRank}
