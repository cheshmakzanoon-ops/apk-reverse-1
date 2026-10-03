local UIActContinuePayLackPanel = {
  Name = UIWindowNames.UIActContinuePayLackPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActContinuePay.UIActContinuePayLackPanel.Controller.UIActContinuePayLackPanelCtrl"),
  View = require("UI.UIActContinuePay.UIActContinuePayLackPanel.View.UIActContinuePayLackPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ContinuePay/UIContinuePayLackPanel.prefab"
}
return {UIActContinuePayLackPanel = UIActContinuePayLackPanel}
