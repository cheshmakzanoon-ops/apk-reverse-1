local UIForceUpdateTip = {
  Name = UIWindowNames.UIForceUpdateTip,
  Layer = UILayer.TopMost,
  Ctrl = require("UI.UIForceUpdateTip.Controller.UIForceUpdateTipCtrl"),
  View = require("UI.UIForceUpdateTip.View.UIForceUpdateTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIForceUpdateTip.prefab"
}
return {UIForceUpdateTip = UIForceUpdateTip}
