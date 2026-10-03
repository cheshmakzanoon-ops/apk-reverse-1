local UITCViewCardDeckPanel = {
  Name = UIWindowNames.UITCViewCardDeckPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCViewCardDeckPanel.Ctrl.UITCViewCardDeckPanelCtrl"),
  View = require("UI.LWUITC.UITCViewCardDeckPanel.View.UITCViewCardDeckPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/ViewCardDeck/UITCViewCardDeckPanel.prefab"
}
return {UITCViewCardDeckPanel = UITCViewCardDeckPanel}
