local UIRedenvelopeReceiveInfo = {
  Name = UIWindowNames.UIRedenvelopeReceiveInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRedenvelope.UIRedenvelopeReceiveInfo.Controller.UIRedenvelopeReceiveInfoCtrl"),
  View = require("UI.UIRedenvelope.UIRedenvelopeReceiveInfo.View.UIRedenvelopeReceiveInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UIRedenvelopeReceiveInfo.prefab"
}
return {UIRedenvelopeReceiveInfo = UIRedenvelopeReceiveInfo}
