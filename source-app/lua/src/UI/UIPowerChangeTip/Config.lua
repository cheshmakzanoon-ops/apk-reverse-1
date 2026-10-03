local UIPositionTip = {
  Name = UIWindowNames.UIPowerChangeTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIPowerChangeTip.Controller.UIPowerChangeTipCtrl"),
  View = require("UI.UIPowerChangeTip.View.UIPowerChangeTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIPowerChangeTip.prefab"
}
return {UIPositionTip = UIPositionTip}
