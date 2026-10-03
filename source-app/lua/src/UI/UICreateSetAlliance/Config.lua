local UICreateSetAlliance = {
  Name = UIWindowNames.UICreateSetAlliance,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICreateSetAlliance.Controller.UICreateSetAllianceCtrl"),
  View = require("UI.UICreateSetAlliance.View.UICreateSetAllianceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICreateSetAlliance/UICreateSetAlliance.prefab"
}
return {UICreateSetAlliance = UICreateSetAlliance}
