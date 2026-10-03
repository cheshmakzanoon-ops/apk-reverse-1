local UIAllianceHelp = {
  Name = UIWindowNames.UIAllianceHelp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceHelp.Controller.UIAllianceHelpCtrl"),
  View = require("UI.UIAlliance.UIAllianceHelp.View.UIAllianceHelpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceHelp.prefab"
}
return {UIAllianceHelp = UIAllianceHelp}
