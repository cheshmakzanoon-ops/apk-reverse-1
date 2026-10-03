local UINoToggleConfirm = {
  Name = UIWindowNames.UINoToggleConfirm,
  Layer = UILayer.Info,
  Ctrl = require("UI.UINoToggleConfirm.Controller.UINoToggleConfirmCtrl"),
  View = require("UI.UINoToggleConfirm.View.UINoToggleConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICapacity/UINoToggleConfirm.prefab"
}
return {UINoToggleConfirm = UINoToggleConfirm}
