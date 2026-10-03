local UIBindAccount = {
  Name = UIWindowNames.UIBindAccount,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIBindAccount.Controller.UIBindAccountCtrl"),
  View = require("UI.UIAccount2.UIBindAccount.View.UIBindAccount"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIBindAccount.prefab"
}
return {UIBindAccount = UIBindAccount}
