local LWAccountBindTip = {
  Name = UIWindowNames.LWAccountBindTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWAccountBindTip.Controller.LWAccountBindTipCtrl"),
  View = require("UI.LWAccountBindTip.View.LWAccountBindTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWAccountBindTip/LWUIAccountBindTip.prefab",
  CustomKeyCodeEscape = true
}
return {LWAccountBindTip = LWAccountBindTip}
