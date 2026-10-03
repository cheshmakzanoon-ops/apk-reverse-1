local UILWAlRankRewardPanel = {
  Name = UIWindowNames.UILWAlRankRewardPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlRankReward.Controller.UILWAlRankRewardPanelCtrl"),
  View = require("UI.UILWAlliance.UILWAlRankReward.View.UILWAlRankRewardPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlRankReward.prefab"
}
return {UILWAlRankRewardPanel = UILWAlRankRewardPanel}
