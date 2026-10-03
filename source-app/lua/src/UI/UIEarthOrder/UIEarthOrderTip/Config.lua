local UIEarthOrderTip = {
  Name = UIWindowNames.UIEarthOrderTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIEarthOrder.UIEarthOrderTip.Controller.UIEarthOrderTipCtrl"),
  View = require("UI.UIEarthOrder.UIEarthOrderTip.View.UIEarthOrderTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIEarthOrder/UIEarthOrderTip.prefab"
}
return {UIEarthOrderTip = UIEarthOrderTip}
