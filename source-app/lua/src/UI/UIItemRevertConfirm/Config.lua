local UIItemRevertConfirm = {
  Name = UIWindowNames.UIItemRevertConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIItemRevertConfirm.Controller.UIItemRevertConfirmCtrl"),
  View = require("UI.UIItemRevertConfirm.View.UIItemRevertConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIItemRevert/UIItemRevertConfirm.prefab",
  HideBack = false,
  CustomKeyCodeEscape = false
}
return {UIItemRevertConfirm = UIItemRevertConfirm}
