local UIEarthOrder = {
  Name = UIWindowNames.UIEarthOrder,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIEarthOrder.UIEarthOrder.Controller.UIEarthOrderCtrl"),
  View = require("UI.UIEarthOrder.UIEarthOrder.View.UIEarthOrderView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIEarthOrder/UIEarthOrder.prefab"
}
return {UIEarthOrder = UIEarthOrder}
