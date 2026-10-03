local LWSeasonBuild = {
  Name = UIWindowNames.UILWSeasonBuild,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonBuild.Controller.LWSeasonBuildCtrl"),
  View = require("UI.LWSeason.LWSeasonBuild.View.LWSeasonBuildView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonBuild.prefab"
}
return {LWSeasonBuild = LWSeasonBuild}
