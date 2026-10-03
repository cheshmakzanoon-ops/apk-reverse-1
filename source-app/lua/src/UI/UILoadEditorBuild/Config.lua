local UILoadEditorBuild = {
  Name = UIWindowNames.UILoadEditorBuild,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILoadEditorBuild.Controller.UILoadEditorBuildCtrl"),
  View = require("UI.UILoadEditorBuild.View.UILoadEditorBuildView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Build/LoadEditorBuild.prefab"
}
return {UILoadEditorBuild = UILoadEditorBuild}
