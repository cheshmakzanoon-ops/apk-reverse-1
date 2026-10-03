local UILoginConfirm = {
  Name = UIWindowNames.UILoginConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UILoginConfirm.Controller.UILoginConfirmCtrl"),
  View = require("UI.UIAccount2.UILoginConfirm.View.UILoginConfirm"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UILoginConfirm.prefab"
}
return {UILoginConfirm = UILoginConfirm}
