local UIMain = {
  Name = UIWindowNames.UIMain,
  Layer = UILayer.UIResource,
  Ctrl = require("UI.LWMainUI.Controller.LWMainUICtrl"),
  View = require("UI.LWMainUI.View.LWMainUIView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/LWMainUI.prefab"
}
return {UIMain = UIMain}
