local UIGovernmentActivityPopup = {
  Name = UIWindowNames.UIGovernmentActivityPopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ActivityPopup.Controller.ActivityPopupCtrl"),
  View = require("UI.UIGovernment.ActivityPopup.View.ActivityPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ActivityPopup.prefab"
}
return {UIGovernmentActivityPopup = UIGovernmentActivityPopup}
