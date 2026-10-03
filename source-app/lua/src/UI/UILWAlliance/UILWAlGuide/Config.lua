local UILWAlGuide = {
  Name = UIWindowNames.UILWAlGuide,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlGuide.Controller.UILWAlGuideCtrl"),
  View = require("UI.UILWAlliance.UILWAlGuide.View.UILWAlGuideView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlGuide.prefab"
}
return {UILWAlGuide = UILWAlGuide}
