local UIPositionTip = {
  Name = UIWindowNames.UIPositionTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPositionTip.Controller.UIPositionTipCtrl"),
  View = require("UI.UIPositionTip.View.UIPositionTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIPositionTips.prefab"
}
return {UIPositionTip = UIPositionTip}
