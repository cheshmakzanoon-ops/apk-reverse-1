local UITCCardInfoPanel = {
  Name = UIWindowNames.UITCCardInfoPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCCardInfoPanel.Ctrl.UITCCardInfoPanelCtrl"),
  View = require("UI.LWUITC.UITCCardInfoPanel.View.UITCCardInfoPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/CardInfo/UITCCardInfoPanel.prefab"
}
return {UITCCardInfoPanel = UITCCardInfoPanel}
