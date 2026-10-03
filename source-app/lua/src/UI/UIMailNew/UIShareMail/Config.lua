local UIShareMail = {
  Name = UIWindowNames.UIShareMail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMailNew.UIShareMail.Controller.UIShareMailCtrl"),
  View = require("UI.UIMailNew.UIShareMail.View.UIShareMailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Mail/UIShareMail.prefab"
}
return {UIShareMail = UIShareMail}
