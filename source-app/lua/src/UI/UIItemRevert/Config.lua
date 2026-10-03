local UIItemRevert = {
  Name = UIWindowNames.UIItemRevert,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIItemRevert.Controller.UIItemRevertCtrl"),
  View = require("UI.UIItemRevert.View.UIItemRevertView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIItemRevert/UIItemRevert.prefab",
  HideBack = false,
  CustomKeyCodeEscape = false
}
return {UIItemRevert = UIItemRevert}
