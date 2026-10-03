local UICommonConfirm = {
  Name = UIWindowNames.UICommonConfirm,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonConfirm.Controller.UICommonConfirmCtrl"),
  View = require("UI.UICommonConfirm.View.UICommonConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICapacity/UICommonConfirm.prefab"
}
return {UICommonConfirm = UICommonConfirm}
