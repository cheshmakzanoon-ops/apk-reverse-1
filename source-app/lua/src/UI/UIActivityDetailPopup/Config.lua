local UIActivityDetailPopup = {
  Name = UIWindowNames.UIActivityDetailPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityDetailPopup.Controller.UIActivityDetailPopupCtrl"),
  View = require("UI.UIActivityDetailPopup.View.UIActivityDetailPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UIActivityDetailPopup.prefab"
}
return {UIActivityDetailPopup = UIActivityDetailPopup}
