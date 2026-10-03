local UILWScienceMain = {
  Name = UIWindowNames.UILWScienceMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWScience.UILWScienceMain.Controller.UILWScienceMainCtrl"),
  View = require("UI.UILWScience.UILWScienceMain.View.UILWScienceMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWScience/UILWScienceMain.prefab",
  HideBack = true
}
return {UILWScienceMain = UILWScienceMain}
