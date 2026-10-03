local UIAccountIsR5Confirm = {
  Name = UIWindowNames.UIAccountIsR5Confirm,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIAccount2.UIAccountIsR5Confirm.Controller.UIAccountIsR5ConfirmCtrl"),
  View = require("UI.UIAccount2.UIAccountIsR5Confirm.View.UIAccountIsR5ConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIAccountIsR5Confirm.prefab"
}
return {UIAccountIsR5Confirm = UIAccountIsR5Confirm}
