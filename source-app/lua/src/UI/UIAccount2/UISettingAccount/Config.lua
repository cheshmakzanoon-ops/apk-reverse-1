local UISettingAccount = {
  Name = UIWindowNames.UISettingAccount,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UISettingAccount.Controller.UISettingAccountCtrl"),
  View = require("UI.UIAccount2.UISettingAccount.View.UISettingAccount"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UISettingAccount.prefab"
}
return {UISettingAccount = UISettingAccount}
