local UISellConfirm = {
  Name = UIWindowNames.UISellConfirm,
  Layer = UILayer.Info,
  Ctrl = require("UI.UISellConfirm.Controller.UISellConfirmCtrl"),
  View = require("UI.UISellConfirm.View.UISellConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICapacity/UISellConfirm.prefab"
}
return {UISellConfirm = UISellConfirm}
