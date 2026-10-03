local UILaunchSuccess = {
  Name = UIWindowNames.UILaunchSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIEarthOrder.UILaunchSuccess.Controller.UILaunchSuccessCtrl"),
  View = require("UI.UIEarthOrder.UILaunchSuccess.View.UILaunchSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIEarthOrder/UILaunchSuccess.prefab"
}
return {UILaunchSuccess = UILaunchSuccess}
