local UISoldierDetails = {
  Name = UIWindowNames.UISoldierDetails,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISoldierDetails.Controller.UISoldierDetailsCtrl"),
  View = require("UI.UISoldierDetails.View.UISoldierDetailsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildDispatching/UISoldierDetails.prefab"
}
return {UISoldierDetails = UISoldierDetails}
