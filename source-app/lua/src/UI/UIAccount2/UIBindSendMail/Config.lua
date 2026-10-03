local UIBindSendMail = {
  Name = UIWindowNames.UIBindSendMail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount2.UIBindSendMail.Controller.UIBindSendMailCtrl"),
  View = require("UI.UIAccount2.UIBindSendMail.View.UIBindSendMail"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIBindSendMail.prefab"
}
return {UIBindSendMail = UIBindSendMail}
