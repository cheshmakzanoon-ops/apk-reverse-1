local LWUIBuildDetails = {
  Name = UIWindowNames.LWUIBuildDetails,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIBuildDetails.Controller.LWUIBuildDetailsCtrl"),
  View = require("UI.LWUIBuildDetails.View.LWUIBuildDetailsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildDispatching/LWUIBuildDetails.prefab"
}
return {LWUIBuildDetails = LWUIBuildDetails}
