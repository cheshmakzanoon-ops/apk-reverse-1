local UIBuildDetails = {
  Name = UIWindowNames.UIBuildDetails,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBuildDetails.Controller.UIBuildDetailsCtrl"),
  View = require("UI.UIBuildDetails.View.UIBuildDetailsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIBuildDetails.prefab"
}
return {UIBuildDetails = UIBuildDetails}
