local UICapacityTip = {
  Name = UIWindowNames.UICapacityTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICapacityTip.Controller.UICapacityTipCtrl"),
  View = require("UI.UICapacityTip.View.UICapacityTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICapacity/UICapacityTips.prefab"
}
return {UICapacityTip = UICapacityTip}
