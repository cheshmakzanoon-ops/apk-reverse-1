local UIModifySuccess = {
  Name = UIWindowNames.UIModifySuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIModifySuccess.Controller.UIModifySuccessCtrl"),
  View = require("UI.UIAccount2.UIModifySuccess.View.UIModifySuccess"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIModifySuccess.prefab"
}
return {UIModifySuccess = UIModifySuccess}
