local LWUIBuildingHelperView = {
  Name = UIWindowNames.LWUIBuildingHelperView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIBuildingHelper.Ctrl.LWUIBuildingHelperCtrl"),
  View = require("UI.LWUIBuildingHelper.View.LWUIBuildingHelperView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIBuildingHelper/LWUIBuildingHelper.prefab"
}
return {LWUIBuildingHelperView = LWUIBuildingHelperView}
