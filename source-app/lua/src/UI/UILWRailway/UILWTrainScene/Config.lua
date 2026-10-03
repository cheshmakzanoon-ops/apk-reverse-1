local UILWTrainScene = {
  Name = UIWindowNames.UILWTrainScene,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UILWTrainScene.Controller.UILWTrainSceneCtrl"),
  View = require("UI.UILWRailway.UILWTrainScene.View.UILWTrainSceneView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UILWTrainScene.prefab",
  HideBack = true
}
return {UILWTrainScene = UILWTrainScene}
