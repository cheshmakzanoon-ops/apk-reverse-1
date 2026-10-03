local UIPositionShareConfirm = {
  Name = UIWindowNames.UIPositionShareConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPositionShareConfirm.Controller.UIPositionShareConfirmCtrl"),
  View = require("UI.UIPositionShareConfirm.View.UIPositionShareConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIPositionShareConfirm.prefab"
}
return {UIPositionShareConfirm = UIPositionShareConfirm}
