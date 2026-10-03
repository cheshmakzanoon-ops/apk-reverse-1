local UIPrivacyKR = {
  Name = UIWindowNames.UIPrivacyKR,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIPrivacyKR.Controller.UIPrivacyKRCtrl"),
  View = require("UI.UIPrivacyKR.View.UIPrivacyKRView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIPrivacy/UIPrivacyKR.prefab"
}
return {UIPrivacyKR = UIPrivacyKR}
