local UIChooseSwitchAccount = {
  Name = UIWindowNames.UIChooseSwitchAccount,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIChooseSwitchAccount.Controller.UIChooseSwitchAccountCtrl"),
  View = require("UI.UIAccount2.UIChooseSwitchAccount.View.UIChooseSwitchAccountView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIChooseSwitchAccount.prefab"
}
return {UIChooseSwitchAccount = UIChooseSwitchAccount}
