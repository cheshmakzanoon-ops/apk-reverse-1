local UIGovernmentEmail = {
  Name = UIWindowNames.UIGovernmentEmail_v2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.EmailV2.Controller.EmailCtrl_v2"),
  View = require("UI.UIGovernment.EmailV2.View.EmailView_v2"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/Email_v2.prefab",
  HideBack = true
}
return {UIGovernmentEmail = UIGovernmentEmail}
