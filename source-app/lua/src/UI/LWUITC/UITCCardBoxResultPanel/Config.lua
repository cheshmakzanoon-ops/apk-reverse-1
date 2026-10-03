local UITCCardBoxResultPanel = {
  Name = UIWindowNames.UITCCardBoxResultPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCCardBoxResultPanel.Ctrl.UITCCardBoxResultPanelCtrl"),
  View = require("UI.LWUITC.UITCCardBoxResultPanel.View.UITCCardBoxResultPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/UITCCardBoxResultPanel.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UITCCardBoxResultPanel = UITCCardBoxResultPanel}
