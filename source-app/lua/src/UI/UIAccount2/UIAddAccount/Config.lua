local UIAddAccount = {
  Name = UIWindowNames.UIAddAccount,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIAddAccount.Controller.UIAddAccountCtrl"),
  View = require("UI.UIAccount2.UIAddAccount.View.UIAddAccount"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIAddAccount.prefab"
}
return {UIAddAccount = UIAddAccount}
