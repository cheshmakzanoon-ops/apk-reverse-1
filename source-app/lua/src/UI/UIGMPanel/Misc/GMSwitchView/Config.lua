local UIGMSwitchView = {
  Name = UIWindowNames.UIGMSwitchView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGMPanel.Misc.GMSwitchView.UIGMSwitchCtrl"),
  View = require("UI.UIGMPanel.Misc.GMSwitchView.UIGMSwitchView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGMPanel/GMSwitchView/UIGMSwitchView.prefab"
}
return {UIGMSwitchView = UIGMSwitchView}
