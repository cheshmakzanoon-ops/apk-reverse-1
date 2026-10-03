local T11PowerInfoView = {
  Name = UIWindowNames.T11PowerInfoView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11PowerInfo.Ctrl.T11PowerInfoCtrl"),
  View = require("UI.T11PowerInfo.View.T11PowerInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11/T11PowerInfo/T11PowerInfo.prefab"
}
return {T11PowerInfoView = T11PowerInfoView}
