local UIDelAllAcctProtConfirm = {
  Name = UIWindowNames.UIDelAllAcctProtConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIDeleteAllAccount.UIDelAllAcctProtConfirm.Controller.UIDelAllAcctProtConfirmCtrl"),
  View = require("UI.UIAccount2.UIDeleteAllAccount.UIDelAllAcctProtConfirm.View.UIDelAllAcctProtConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIDeleteAllAccount/UIDelAllAcctProtConfirm.prefab"
}
return {UIDelAllAcctProtConfirm = UIDelAllAcctProtConfirm}
