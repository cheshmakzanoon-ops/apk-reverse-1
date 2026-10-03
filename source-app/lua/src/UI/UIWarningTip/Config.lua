local UIWarningTip = {
  Name = UIWindowNames.UIWarningTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWarningTip.Controller.UIWarningTipCtrl"),
  View = require("UI.UIWarningTip.View.UIWarningTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWarningTip/UIWarningTip.prefab"
}
return {UIWarningTip = UIWarningTip}
