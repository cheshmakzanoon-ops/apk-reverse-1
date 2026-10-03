local LWUICityRebuildNewView = {
  Name = UIWindowNames.LWUICityRebuildNewView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWCityRebuild.Ctrl.LWUICityRebuildNewCtrl"),
  View = require("UI.LWCityRebuild.View.LWUICityRebuildNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWCityState/LWUICityRebuildNew.prefab"
}
return {LWUICityRebuildNewView = LWUICityRebuildNewView}
