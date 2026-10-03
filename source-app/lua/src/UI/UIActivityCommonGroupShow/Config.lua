local UIActivityCommonGroupShow = {
  Name = UIWindowNames.UIActivityCommonGroupShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCommonGroupShow.Controller.UIActivityCommonGroupShowCtrl"),
  View = require("UI.UIActivityCommonGroupShow.View.UIActivityCommonGroupShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UIActivityCommonGroupShow.prefab",
  HideBack = true
}
return {UIActivityCommonGroupShow = UIActivityCommonGroupShow}
