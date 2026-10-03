local UISiegeSuccess = {
  Name = UIWindowNames.UISiegeSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISiegeSuccess.Controller.UISiegeSuccessCtrl"),
  View = require("UI.UISiegeSuccess.View.UISiegeSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UISiegeSuccess.prefab"
}
return {UISiegeSuccess = UISiegeSuccess}
