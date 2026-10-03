local UIStrComRankingRewardPanel = {
  Name = UIWindowNames.UIStrComRankingRewardPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStrComRankingRewardPanel.Controller.UIStrComRankingRewardPanelCtrl"),
  View = require("UI.UIStrComRankingRewardPanel.View.UIStrComRankingRewardPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/StrongestCommander/UIStrComRankingRewardsPanel.prefab"
}
return {UIStrComRankingRewardPanel = UIStrComRankingRewardPanel}
