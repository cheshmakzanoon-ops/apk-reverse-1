local UILWAlMain = {
  Name = UIWindowNames.UILWAlMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlMain.Controller.UILWAlMainCtrl"),
  View = require("UI.UILWAlliance.UILWAlMain.View.UILWAlMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlMain.prefab",
  HideBack = true
}
return {UILWAlMain = UILWAlMain}
