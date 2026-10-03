local UITCCardBoxPanel = {
  Name = UIWindowNames.UITCCardBoxPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCCardBoxPanel.Ctrl.UITCCardBoxPanelCtrl"),
  View = require("UI.LWUITC.UITCCardBoxPanel.View.UITCCardBoxPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/UITCCardBoxPanel.prefab",
  HideBack = true
}
return {UITCCardBoxPanel = UITCCardBoxPanel}
