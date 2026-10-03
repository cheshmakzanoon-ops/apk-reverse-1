local UINpcTalkLayer = {
  Name = UIWindowNames.UINpcTalkLayer,
  Layer = UILayer.Scene,
  Ctrl = require("UI.UICityScene.UINpcTalkLayer.Controller.UINpcTalkLayerCtrl"),
  View = require("UI.UICityScene.UINpcTalkLayer.View.UINpcTalkLayer"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICityScene/UINpcTalkLayer.prefab"
}
return {UINpcTalkLayer = UINpcTalkLayer}
