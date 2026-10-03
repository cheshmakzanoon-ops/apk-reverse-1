local UIPositionTip = {
  Name = UIWindowNames.UIWorldZoneChangeTip,
  Layer = UILayer.Scene,
  Ctrl = require("UI.UIWorldZoneChangeTip.Controller.UIWorldZoneChangeTipCtrl"),
  View = require("UI.UIWorldZoneChangeTip.View.UIWorldZoneChangeTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWWorld/UIWorldZoneChangeTip.prefab"
}
return {UIPositionTip = UIPositionTip}
