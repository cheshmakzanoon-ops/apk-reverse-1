local UISetting = {
  Name = UIWindowNames.UIGMBar,
  Layer = UILayer.TopMost,
  Ctrl = require("UI.UIGMPanel.GMBar.UIGMBarCtrl"),
  View = require("UI.UIGMPanel.GMBar.UIGMBarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGMPanel/GMBar/UIGMBar.prefab"
}
return {UISetting = UISetting}
