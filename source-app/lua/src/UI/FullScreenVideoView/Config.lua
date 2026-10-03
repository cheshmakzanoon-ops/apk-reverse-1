local FullScreenVideoView = {
  Name = UIWindowNames.FullScreenVideoView,
  Layer = UILayer.Info,
  Ctrl = require("UI.FullScreenVideoView.Ctrl.FullScreenVideoViewCtrl"),
  View = require("UI.FullScreenVideoView.View.FullScreenVideoViewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/New/FullPanel/FullScreenVideoView.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {FullScreenVideoView = FullScreenVideoView}
