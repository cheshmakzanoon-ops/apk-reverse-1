local UIAccountDeleteVerify = {
  Name = UIWindowNames.UIAccountDeleteVerify,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIAccount2.UIAccountDeleteVerify.Controller.UIAccountDeleteVerifyCtrl"),
  View = require("UI.UIAccount2.UIAccountDeleteVerify.View.UIAccountDeleteVerifyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UDeleteAccountVerify.prefab"
}
return {UIAccountDeleteVerify = UIAccountDeleteVerify}
