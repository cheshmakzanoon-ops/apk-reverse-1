local UINewsShareView = {
  Name = UIWindowNames.UINewsShareView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.NewsShare.Ctrl.UINewsShareCtrl"),
  View = require("UI.NewsShare.View.UINewsShareView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWNewsCenter/UINewsShareView.prefab"
}
return {UINewsShareView = UINewsShareView}
