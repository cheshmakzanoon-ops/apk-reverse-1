local UIAllianceScience = {
  Name = UIWindowNames.UIAllianceScience,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIAlliance.UIAllianceScience.Controller.UIAllianceScienceCtrl"),
  View = require("UI.UIAlliance.UIAllianceScience.View.UIAllianceScienceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceScience.prefab"
}
return {UIAllianceScience = UIAllianceScience}
