local UIRedenvelopeView = {
  Name = UIWindowNames.UIRedenvelopeView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRedenvelope.UIRedenvelopeView.Controller.UIRedenvelopeCtrl"),
  View = require("UI.UIRedenvelope.UIRedenvelopeView.View.UIRedenvelopeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UIRedenvelopeView.prefab"
}
return {UIRedenvelopeView = UIRedenvelopeView}
