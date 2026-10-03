local UIDelAllAcctSendReqConfirm = {
  Name = UIWindowNames.UIDelAllAcctSendReqConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIDeleteAllAccount.UIDelAllAcctSendReqConfirm.Controller.UIDelAllAcctSendReqConfirmCtrl"),
  View = require("UI.UIAccount2.UIDeleteAllAccount.UIDelAllAcctSendReqConfirm.View.UIDelAllAcctSendReqConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIDeleteAllAccount/UIDelAllAcctSendReqConfirm.prefab"
}
return {UIDelAllAcctSendReqConfirm = UIDelAllAcctSendReqConfirm}
