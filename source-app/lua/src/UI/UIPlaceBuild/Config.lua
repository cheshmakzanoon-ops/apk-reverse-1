local UIPlaceBuild = {
  Name = UIWindowNames.UIPlaceBuild,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPlaceBuild.Controller.UIPlaceBuildCtrl"),
  View = require("UI.UIPlaceBuild.View.UIPlaceBuildView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Build/UIPlaceBuild.prefab"
}
return {UIPlaceBuild = UIPlaceBuild}
