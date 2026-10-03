local UINpcQN = {
  Name = UIWindowNames.UINpcQN,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UINpcQN.Controller.UINpcQNCtrl"),
  View = require("UI.UINpcQN.View.UINpcQNView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UINpcQA/UINpcQN.prefab"
}
return {UINpcQN = UINpcQN}
