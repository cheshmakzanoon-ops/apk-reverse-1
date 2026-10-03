local UIChangeMail = {
  Name = UIWindowNames.UIChangeMail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount.UIChangeMail.Controller.UIChangeMailCtrl"),
  View = require("UI.UIAccount.UIChangeMail.View.UIChangeMailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIChangeMail.prefab"
}
return {UIChangeMail = UIChangeMail}
