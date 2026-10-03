local UIRoleListShow = {
  Name = UIWindowNames.UIRoleListShow,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIAccount2.UIDeleteAllAccount.UIRoleListShow.Controller.UIRoleListShowCtrl"),
  View = require("UI.UIAccount2.UIDeleteAllAccount.UIRoleListShow.View.UIRoleListShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIDeleteAllAccount/UIRoleListShow.prefab"
}
return {UIRoleListShow = UIRoleListShow}
