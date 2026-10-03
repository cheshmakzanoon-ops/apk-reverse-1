local UIAccountSetConfirm = {
  Name = UIWindowNames.UIAccountSetConfirm,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIAccount2.UIAccountSetConfirm.Controller.UIAccountSetConfirmCtrl"),
  View = require("UI.UIAccount2.UIAccountSetConfirm.View.UIAccountSetConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIAccountSetConfirm.prefab"
}
return {UIAccountSetConfirm = UIAccountSetConfirm}
