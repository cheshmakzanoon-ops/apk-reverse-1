local UICreateAccount = {
  Name = UIWindowNames.UICreateAccount,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UICreateAccount.Controller.UICreateAccountCtrl"),
  View = require("UI.UIAccount2.UICreateAccount.View.UICreateAccount"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UICreateAccount.prefab"
}
return {UICreateAccount = UICreateAccount}
