local UIDelAllAcctInfoConfirm = {
  Name = UIWindowNames.UIDelAllAcctInfoConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIDeleteAllAccount.UIDelAllAcctInfoConfirm.Controller.UIDelAllAcctInfoConfirmCtrl"),
  View = require("UI.UIAccount2.UIDeleteAllAccount.UIDelAllAcctInfoConfirm.View.UIDelAllAcctInfoConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIDeleteAllAccount/UIDelAllAcctInfoConfirm.prefab"
}
return {UIDelAllAcctInfoConfirm = UIDelAllAcctInfoConfirm}
