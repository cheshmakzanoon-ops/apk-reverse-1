local UIDeviceManage = {
  Name = UIWindowNames.UIDeviceManage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIDeviceManage.Controller.UIDeviceManageCtrl"),
  View = require("UI.UIAccount2.UIDeviceManage.View.UIDeviceManageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIDeviceManage.prefab"
}
return {UIDeviceManage = UIDeviceManage}
