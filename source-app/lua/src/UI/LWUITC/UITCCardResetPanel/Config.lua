local UITCCardResetPanel = {
  Name = UIWindowNames.UITCCardResetPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCCardResetPanel.Ctrl.UITCCardResetPanelCtrl"),
  View = require("UI.LWUITC.UITCCardResetPanel.View.UITCCardResetPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/CardReset/UITCCardReset.prefab"
}
return {UITCCardResetPanel = UITCCardResetPanel}
