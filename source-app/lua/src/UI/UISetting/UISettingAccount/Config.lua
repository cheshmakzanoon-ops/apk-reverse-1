local UISettingAccount = {
  Name = UIWindowNames.UISettingAccount,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UISettingAccount.Controller.UISettingAccountCtrl"),
  View = require("UI.UISetting.UISettingAccount.View.UISettingAccountView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingAccount.prefab"
}
return {UISettingAccount = UISettingAccount}
