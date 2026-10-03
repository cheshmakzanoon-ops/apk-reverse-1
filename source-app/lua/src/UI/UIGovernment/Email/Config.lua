local UIGovernmentEmail = {
  Name = UIWindowNames.UIGovernmentEmail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.Email.Controller.EmailCtrl"),
  View = require("UI.UIGovernment.Email.View.EmailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/Email.prefab"
}
return {UIGovernmentEmail = UIGovernmentEmail}
