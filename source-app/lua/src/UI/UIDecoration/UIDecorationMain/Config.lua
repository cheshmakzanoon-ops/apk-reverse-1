local UIDecorationMain = {
  Name = UIWindowNames.UIDecorationMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDecoration.UIDecorationMain.Controller.UIDecorationMainCtrl"),
  View = require("UI.UIDecoration.UIDecorationMain.View.UIDecorationMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDecoration/UIDecorationMainView.prefab",
  HideBack = true
}
return {UIDecorationMain = UIDecorationMain}
