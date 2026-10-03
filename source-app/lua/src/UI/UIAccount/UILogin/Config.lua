local UILogin = {
  Name = UIWindowNames.UILogin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount.UILogin.Controller.UILoginCtrl"),
  View = require("UI.UIAccount.UILogin.View.UILoginView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UILogin.prefab"
}
return {UILogin = UILogin}
