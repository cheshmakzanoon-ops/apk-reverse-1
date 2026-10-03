local UIDelAllAcctResultConfirm = {
  Name = UIWindowNames.UIDelAllAcctResultConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIDeleteAllAccount.UIDelAllAcctResultConfirm.Controller.UIDelAllAcctResultConfirmCtrl"),
  View = require("UI.UIAccount2.UIDeleteAllAccount.UIDelAllAcctResultConfirm.View.UIDelAllAcctResultConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIDeleteAllAccount/UIDelAllAcctResultConfirm.prefab",
  CustomKeyCodeEscape = true
}
return {UIDelAllAcctResultConfirm = UIDelAllAcctResultConfirm}
