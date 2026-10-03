local UILWMailMain = {
  Name = UIWindowNames.UILWMailMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWMail.UILWMailMain.Controller.UILWMailMainCtrl"),
  View = require("UI.UILWMail.UILWMailMain.View.UILWMailMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMail/UILWMailMain.prefab",
  CustomKeyCodeEscape = true,
  HideBack = true
}
return {UILWMailMain = UILWMailMain}
