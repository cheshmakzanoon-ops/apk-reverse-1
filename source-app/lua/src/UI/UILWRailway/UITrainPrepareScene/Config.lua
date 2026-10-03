local UITrainPrepareScene = {
  Name = UIWindowNames.UITrainPrepareScene,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainPrepareScene.Controller.UITrainPrepareSceneCtrl"),
  View = require("UI.UILWRailway.UITrainPrepareScene.View.UITrainPrepareSceneView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainPrepareScene.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UITrainPrepareScene = UITrainPrepareScene}
