local LWUIMoveCityTip = {
  Name = UIWindowNames.LWUIMoveCityTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMoveCityTip.Ctrl.LWUIMoveCityTipCtrl"),
  View = require("UI.LWUIMoveCityTip.View.LWUIMoveCityTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/LWUIMoveCityTip.prefab"
}
return {LWUIMoveCityTip = LWUIMoveCityTip}
