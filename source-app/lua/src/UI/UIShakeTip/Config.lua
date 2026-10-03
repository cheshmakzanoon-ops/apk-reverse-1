local UIShakeTip = {
  Name = UIWindowNames.UIShakeTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIShakeTip.Ctrl.UIShakeTipCtrl"),
  View = require("UI.UIShakeTip.View.UIShakeTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIShakeTip/UIShakeTip.prefab"
}
return {UIShakeTip = UIShakeTip}
