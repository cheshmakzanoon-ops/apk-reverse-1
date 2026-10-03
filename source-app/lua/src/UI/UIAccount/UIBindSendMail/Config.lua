local UIBindSendMail = {
  Name = UIWindowNames.UIBindSendMail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAccount.UIBindSendMail.Controller.UIBindSendMailCtrl"),
  View = require("UI.UIAccount.UIBindSendMail.View.UIBindSendMailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIBindSendMail.prefab"
}
return {UIBindSendMail = UIBindSendMail}
