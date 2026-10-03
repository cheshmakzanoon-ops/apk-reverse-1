local LWDegradesTip = {
  Name = UIWindowNames.LWDegradesTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWDegradesTip.Controller.LWDegradesTipCtrl"),
  View = require("UI.LWDegradesTip.View.LWDegradesTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMail/LWDegradesTip.prefab"
}
return {LWDegradesTip = LWDegradesTip}
