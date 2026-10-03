local UIActBanquetRankingReward = {
  Name = UIWindowNames.UIActBanquetRankingReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActBanquetRank.RankReward.Controller.UIActBanquetRankingRewardCtrl"),
  View = require("UI.UIActBanquetRank.RankReward.View.UIActBanquetRankingRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ThanksGiving/ThanksGivingBanquetRewardView.prefab"
}
return {UIActBanquetRankingReward = UIActBanquetRankingReward}
