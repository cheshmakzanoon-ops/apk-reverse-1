local UIActContinuePayRewardPreviewPanel = {
  Name = UIWindowNames.UIActContinuePayRewardPreviewPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActContinuePay.UIActContinuePayRewardPreviewPanel.Controller.UIActContinuePayRewardPreviewPanelCtrl"),
  View = require("UI.UIActContinuePay.UIActContinuePayRewardPreviewPanel.View.UIActContinuePayRewardPreviewPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ContinuePay/UIContinuePayRewardPreviewPanel.prefab"
}
return {UIActContinuePayRewardPreviewPanel = UIActContinuePayRewardPreviewPanel}
