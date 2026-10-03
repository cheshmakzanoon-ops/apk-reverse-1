local UIMoveCityTip = {
  Name = UIWindowNames.UIMoveCityTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMoveCityTip.Controller.UIMoveCityTipCtrl"),
  View = require("UI.UIMoveCityTip.View.UIMoveCityTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMoveCityTip/UIMoveCityTip.prefab"
}
return {UIMoveCityTip = UIMoveCityTip}
