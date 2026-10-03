local UIPackageContentTip = {
  Name = UIWindowNames.UIPackageContentTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPackageContentTip.Controller.UIPackageContentTipCtrl"),
  View = require("UI.UIPackageContentTip.View.UIPackageContentTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPackageContentTip/UIPackageContentTip.prefab"
}
return {UIPackageContentTip = UIPackageContentTip}
