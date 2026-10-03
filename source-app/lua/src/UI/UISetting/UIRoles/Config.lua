local UIRoles = {
  Name = UIWindowNames.UIRoles,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UIRoles.Controller.UIRolesCtrl"),
  View = require("UI.UISetting.UIRoles.View.UIRolesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UIRoles.prefab"
}
return {UIRoles = UIRoles}
