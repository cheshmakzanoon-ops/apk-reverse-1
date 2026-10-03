local UILWBagMain = {
  Name = UIWindowNames.UILWBagMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWBag.UILWBagMain.Controller.UILWBagMainCtrl"),
  View = require("UI.UILWBag.UILWBagMain.View.UILWBagMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWBag/UILWBagMain.prefab",
  HideBack = true
}
return {UILWBagMain = UILWBagMain}
