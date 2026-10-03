local T11MainView = {
  Name = UIWindowNames.T11MainView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11MainView.Ctrl.T11MainCtrl"),
  View = require("UI.T11MainView.View.T11MainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/T11MainView.prefab",
  HideBack = true
}
return {T11MainView = T11MainView}
