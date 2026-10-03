local UITutorialAnimation = {
  Name = UIWindowNames.UITutorialAnimation,
  Layer = UILayer.Background,
  Ctrl = require("UI.UICityScene.UITutorialAnimation.Controller.UITutorialAnimationCtrl"),
  View = require("UI.UICityScene.UITutorialAnimation.View.UITutorialAnimation"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICityScene/UITutorialAnimation.prefab"
}
return {UITutorialAnimation = UITutorialAnimation}
