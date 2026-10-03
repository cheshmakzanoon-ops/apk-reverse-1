local UIIOSVersionUpdateTip = {
  Name = UIWindowNames.UIIOSVersionUpdateTip,
  Layer = UILayer.TopMost,
  Ctrl = require("UI.UIIOSVersionUpdateTip.Controller.UIIOSVersionUpdateTipCtrl"),
  View = require("UI.UIIOSVersionUpdateTip.View.UIIOSVersionUpdateTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIIOSVersionUpdateTip/UIIOSVersionUpdateTip.prefab"
}
return {UIIOSVersionUpdateTip = UIIOSVersionUpdateTip}
