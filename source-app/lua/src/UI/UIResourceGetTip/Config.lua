local UIResourceGetTip = {
  Name = UIWindowNames.UIResourceGetTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIResourceGetTip.Controller.UIResourceGetTipCtrl"),
  View = require("UI.UIResourceGetTip.View.UIResourceGetTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIResource/UIResourceGetTip.prefab"
}
return {UIResourceGetTip = UIResourceGetTip}
