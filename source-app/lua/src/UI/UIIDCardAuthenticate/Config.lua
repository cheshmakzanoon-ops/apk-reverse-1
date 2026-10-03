local UIIDCardAuthenticate = {
  Name = UIWindowNames.UIIDCardAuthenticate,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIIDCardAuthenticate.Controller.UIIDCardAuthenticateCtrl"),
  View = require("UI.UIIDCardAuthenticate.View.UIIDCardAuthenticateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIIDCardAuthenticate.prefab"
}
return {UIIDCardAuthenticate = UIIDCardAuthenticate}
