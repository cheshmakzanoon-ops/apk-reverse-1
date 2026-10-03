local UISubWay = {
  Name = UIWindowNames.UISubWay,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISubWay.UISubWayView.Controller.UISubWayCtrl"),
  View = require("UI.UISubWay.UISubWayView.View.UISubWayView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISubWay/UISubWayView.prefab"
}
return {WorldDesUI = UISubWay}
