local UIRedenvelopeSend = {
  Name = UIWindowNames.UIRedenvelopeSend,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRedenvelope.UIRedenvelopeSend.Controller.UIRedenvelopeSendCtrl"),
  View = require("UI.UIRedenvelope.UIRedenvelopeSend.View.UIRedenvelopeSendView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UIRedenvelopeSend.prefab"
}
return {UIRedenvelopeSend = UIRedenvelopeSend}
