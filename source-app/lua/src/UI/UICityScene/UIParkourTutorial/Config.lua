local UIParkourTutorial = {
  Name = UIWindowNames.UIParkourTutorial,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICityScene.UIParkourTutorial.Controller.UIParkourTutorialCtrl"),
  View = require("UI.UICityScene.UIParkourTutorial.View.UIParkourTutorialView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICityScene/UIParkourTutorial.prefab"
}
return {UIParkourTutorial = UIParkourTutorial}
