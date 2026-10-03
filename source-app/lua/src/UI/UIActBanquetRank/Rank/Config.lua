local UIActBanquetRanking = {
  Name = UIWindowNames.UIActBanquetRanking,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActBanquetRank.Rank.Controller.UIActBanquetRankingCtrl"),
  View = require("UI.UIActBanquetRank.Rank.View.UIActBanquetRankingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ThanksGiving/ThanksGivingBanquetRankView.prefab"
}
return {UIActBanquetRanking = UIActBanquetRanking}
