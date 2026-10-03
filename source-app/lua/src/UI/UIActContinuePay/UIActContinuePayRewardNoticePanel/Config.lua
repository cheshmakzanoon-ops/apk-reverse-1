local UIActContinuePayRewardNoticePanel = {
  Name = UIWindowNames.UIActContinuePayRewardNoticePanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActContinuePay.UIActContinuePayRewardNoticePanel.Controller.UIActContinuePayRewardNoticePanelCtrl"),
  View = require("UI.UIActContinuePay.UIActContinuePayRewardNoticePanel.View.UIActContinuePayRewardNoticePanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ContinuePay/UIContinuePayBigRewardPanel.prefab"
}
return {UIActContinuePayRewardNoticePanel = UIActContinuePayRewardNoticePanel}
