local UIActivityLockhartDetailPopup = {
  Name = UIWindowNames.UIActivityLockhartDetailPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityLockhartDetailPopup.Controller.UIActivityLockhartDetailPopupCtrl"),
  View = require("UI.UIActivityLockhartDetailPopup.View.UIActivityLockhartDetailPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Lockhart/LockhartDetailPopup.prefab"
}
return {UIActivityLockhartDetailPopup = UIActivityLockhartDetailPopup}
