local UISetting = {
  Name = UIWindowNames.UIGMLogPanel,
  Layer = UILayer.TopMost,
  Ctrl = require("UI.UIGMPanel.Misc.GMLogPanel.UIGMLogPanelCtrl"),
  View = require("UI.UIGMPanel.Misc.GMLogPanel.UIGMLogPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGMPanel/GMLogPanel/UIGMLogPanel.prefab"
}
return {UISetting = UISetting}
