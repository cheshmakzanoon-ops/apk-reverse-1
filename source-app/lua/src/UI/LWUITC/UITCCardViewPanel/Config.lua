local UITCCardViewPanel = {
  Name = UIWindowNames.UITCCardViewPanel,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWUITC.UITCCardViewPanel.Ctrl.UITCCardViewPanelCtrl"),
  View = require("UI.LWUITC.UITCCardViewPanel.View.UITCCardViewPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/UITCCardViewPanel.prefab"
}
return {UITCCardViewPanel = UITCCardViewPanel}
