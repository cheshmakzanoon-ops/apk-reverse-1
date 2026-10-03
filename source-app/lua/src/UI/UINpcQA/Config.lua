local UINpcQA = {
  Name = UIWindowNames.UINpcQA,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UINpcQA.Controller.UINpcQACtrl"),
  View = require("UI.UINpcQA.View.UINpcQAView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UINpcQA/UINpcQA.prefab"
}
return {UINpcQA = UINpcQA}
