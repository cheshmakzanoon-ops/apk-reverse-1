local UIRedenvelopeReceive = {
  Name = UIWindowNames.UIRedenvelopeReceive,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRedenvelope.UIRedenvelopeReceive.Controller.UIRedenvelopeReceiveCtrl"),
  View = require("UI.UIRedenvelope.UIRedenvelopeReceive.View.UIRedenvelopeReceiveView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UIRedenvelopeReceive.prefab"
}
return {UIRedenvelopeReceive = UIRedenvelopeReceive}
