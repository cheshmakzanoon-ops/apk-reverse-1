local UINoEarthOrder = {
  Name = UIWindowNames.UINoEarthOrder,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIEarthOrder.UINoEarthOrder.Controller.UINoEarthOrderCtrl"),
  View = require("UI.UIEarthOrder.UINoEarthOrder.View.UINoEarthOrderView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIEarthOrder/UINoEarthOrder.prefab"
}
return {UINoEarthOrder = UINoEarthOrder}
