local UIDeviceManageDelConfirm = {
  Name = UIWindowNames.UIDeviceManageDelConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIDeviceDelConfirm.UIDeviceManageDelConfirmCtrl"),
  View = require("UI.UIAccount2.UIDeviceDelConfirm.UIDeviceManageDelConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIDeviceManageDelConfirm.prefab"
}
return {UIDeviceManageDelConfirm = UIDeviceManageDelConfirm}
