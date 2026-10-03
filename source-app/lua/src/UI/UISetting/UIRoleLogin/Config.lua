local UIRoleLogin = {
  Name = UIWindowNames.UIRoleLogin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UIRoleLogin.Controller.UIRoleLoginCtrl"),
  View = require("UI.UISetting.UIRoleLogin.View.UIRoleLoginView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UIRoleLogin.prefab"
}
return {UIRoleLogin = UIRoleLogin}
