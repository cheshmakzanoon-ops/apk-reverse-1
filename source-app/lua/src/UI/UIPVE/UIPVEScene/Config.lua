local UIPVEScene = {
  Name = UIWindowNames.UIPVEScene,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIPVE.UIPVEScene.Controller.UIPVESceneCtrl"),
  View = require("UI.UIPVE.UIPVEScene.View.UIPVESceneView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuidePioneer.prefab"
}
return {UIPVEScene = UIPVEScene}
