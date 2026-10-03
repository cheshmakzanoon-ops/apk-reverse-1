local UIForgetPassword = {
  Name = UIWindowNames.UIForgetPassword,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIForgetPassword.Controller.UIForgetPasswordCtrl"),
  View = require("UI.UIAccount2.UIForgetPassword.View.UIForgetPassword"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIForgetPassword.prefab"
}
return {UIForgetPassword = UIForgetPassword}
