local UITCCardDetailPanel = {
  Name = UIWindowNames.UITCCardDetailPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCCardDetailPanel.Ctrl.UITCCardDetailPanelCtrl"),
  View = require("UI.LWUITC.UITCCardDetailPanel.View.UITCCardDetailPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/UITCCardDetailPanel.prefab"
}
return {UITCCardDetailPanel = UITCCardDetailPanel}
