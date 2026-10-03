local UIScratchOffRankingRewardPage = {
  Name = UIWindowNames.UIScratchOffRankingRewardPage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIScratchOffRankingRewardPage.Ctrl.UIScratchOffRankingRewardPageCtrl"),
  View = require("UI.UIScratchOffRankingRewardPage.View.UIScratchOffRankingRewardPageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIScratchOffRankRewardPage/ScratchOffRankRewardPage.prefab"
}
return {UIScratchOffRankingRewardPage = UIScratchOffRankingRewardPage}
