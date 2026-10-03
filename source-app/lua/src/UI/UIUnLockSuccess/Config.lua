local UIUnLockSuccess = {
  Name = UIWindowNames.UIUnLockSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIUnLockSuccess.Controller.UIUnLockSuccessCtrl"),
  View = require("UI.UIUnLockSuccess.View.UIUnLockSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFactory/UIUnLockSuccess.prefab"
}
return {UIUnLockSuccess = UIUnLockSuccess}
