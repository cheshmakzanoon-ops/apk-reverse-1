local TreasureTenRewardPanelView = {
  Name = UIWindowNames.TreasureTenRewardPanelView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.RewardTen.Ctrl.TreasureTenRewardPanelCtrl"),
  View = require("UI.UIDispatchTask.RewardTen.View.TreasureTenRewardPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DispatchTreasure/TreasureTenRewardPanel.prefab",
  CustomKeyCodeEscape = true
}
return {TreasureTenRewardPanelView = TreasureTenRewardPanelView}
