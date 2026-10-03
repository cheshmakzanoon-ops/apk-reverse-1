local UIPrivacy = {
  Name = UIWindowNames.UIPrivacy,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIPrivacy.Controller.UIPrivacyCtrl"),
  View = require("UI.UIPrivacy.View.UIPrivacyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIPrivacy/UIPrivacy.prefab"
}
return {UIPrivacy = UIPrivacy}
