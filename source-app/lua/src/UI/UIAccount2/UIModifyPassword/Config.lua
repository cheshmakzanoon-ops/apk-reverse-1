local UIModifyPassword = {
  Name = UIWindowNames.UIModifyPassword,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIModifyPassword.Controller.UIModifyPasswordCtrl"),
  View = require("UI.UIAccount2.UIModifyPassword.View.UIModifyPassword"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIModifyPassword.prefab"
}
return {UIModifyPassword = UIModifyPassword}
