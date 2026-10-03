local LWDecorationBookProperty = {
  Name = UIWindowNames.LWDecorationBookProperty,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWDecorationBookProperty.Controller.LWDecorationBookPropertyCtrl"),
  View = require("UI.LWDecorationBookProperty.View.LWDecorationBookPropertyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDecorationBook/UIDecorationBookPropertyDetail.prefab"
}
return {LWDecorationBookProperty = LWDecorationBookProperty}
