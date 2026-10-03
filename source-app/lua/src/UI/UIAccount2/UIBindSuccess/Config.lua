local UIBindSuccess = {
  Name = UIWindowNames.UIBindSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIBindSuccess.Controller.UIBindSuccessCtrl"),
  View = require("UI.UIAccount2.UIBindSuccess.View.UIBindSuccess"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIBindSuccess.prefab"
}
return {UIBindSuccess = UIBindSuccess}
