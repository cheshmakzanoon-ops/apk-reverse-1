local UIShieldBreakTip = {
  Name = UIWindowNames.UIShieldBreakTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIShieldBreakTip.Controller.UIShieldBreakTipCtrl"),
  View = require("UI.UIShieldBreakTip.View.UIShieldBreakTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWCityBuff/UIShieldBreakTip.prefab"
}
return {UIShieldBreakTip = UIShieldBreakTip}
