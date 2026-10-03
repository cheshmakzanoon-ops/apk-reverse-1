local UICreateAlliance = {
  Name = UIWindowNames.UICreateAlliance,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UICreateAlliance.Controller.UICreateAllianceCtrl"),
  View = require("UI.UIAlliance.UICreateAlliance.View.UICreateAllianceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UICreateAlliance.prefab"
}
return {UICreateAlliance = UICreateAlliance}
