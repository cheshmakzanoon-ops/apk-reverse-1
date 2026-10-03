local UIAllianceChangeAbbr = {
  Name = UIWindowNames.UIAllianceChangeAbbr,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceChangeAbbr.Controller.UIAllianceChangeAbbrCtrl"),
  View = require("UI.UIAlliance.UIAllianceChangeAbbr.View.UIAllianceChangeAbbrView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWChangeAllianceAbbr.prefab"
}
return {UIAllianceChangeAbbr = UIAllianceChangeAbbr}
