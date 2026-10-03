local UIPlaceWorldBuild = {
  Name = UIWindowNames.UIPlaceWorldBuild,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPlaceWorldBuild.Controller.UIPlaceWorldBuildCtrl"),
  View = require("UI.UIPlaceWorldBuild.View.UIPlaceWorldBuildView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Build/UIPlaceWorldBuild.prefab"
}
return {UIPlaceWorldBuild = UIPlaceWorldBuild}
