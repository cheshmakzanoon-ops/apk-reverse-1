local UIRoleCreate = {
  Name = UIWindowNames.UIRoleCreate,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UIRoleCreate.Controller.UIRoleCreateCtrl"),
  View = require("UI.UISetting.UIRoleCreate.View.UIRoleCreateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UIRoleCreate.prefab"
}
return {UIRoleCreate = UIRoleCreate}
