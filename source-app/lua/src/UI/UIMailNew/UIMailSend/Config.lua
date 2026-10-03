local UIMailSend = {
  Name = UIWindowNames.UIMailSend,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMailNew.UIMailSend.Controller.UIMailSendCtrl"),
  View = require("UI.UIMailNew.UIMailSend.View.UIMailSendView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Mail/UIMailSend.prefab"
}
return {UIMailSend = UIMailSend}
