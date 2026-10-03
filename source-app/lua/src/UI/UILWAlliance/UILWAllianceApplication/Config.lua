local UILWAllianceApplication = {
  Name = UIWindowNames.UILWAllianceApplication,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAllianceApplication.Controller.UILWAllianceApplicationCtrl"),
  View = require("UI.UILWAlliance.UILWAllianceApplication.View.UILWAllianceApplicationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceApplication.prefab"
}
return {UILWAllianceApplication = UILWAllianceApplication}
