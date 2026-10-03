local UISetting = {
  Name = UIWindowNames.UIGMPanel,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIGMPanel.GMPanel.UIGMPanelCtrl"),
  View = require("UI.UIGMPanel.GMPanel.UIGMPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGMPanel/UIGMPanel.prefab"
}
return {UISetting = UISetting}
