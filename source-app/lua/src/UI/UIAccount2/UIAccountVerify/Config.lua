local UIAccountVerify = {
  Name = UIWindowNames.UIAccountVerify,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIAccountVerify.Controller.UIAccountVerifyCtrl"),
  View = require("UI.UIAccount2.UIAccountVerify.View.UIAccountVerify"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIAccountVerify.prefab"
}
return {UIAccountVerify = UIAccountVerify}
