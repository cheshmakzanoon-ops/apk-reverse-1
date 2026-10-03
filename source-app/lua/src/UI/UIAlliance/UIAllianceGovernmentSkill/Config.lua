local UIAllianceGovernmentSkill = {
  Name = UIWindowNames.UIAllianceGovernmentSkill,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceGovernmentSkill.Controller.UIAllianceGovernmentSkillCtrl"),
  View = require("UI.UIAlliance.UIAllianceGovernmentSkill.View.UIAllianceGovernmentSkillView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/GovernmentSkill.prefab",
  HideBack = true
}
return {UIAllianceGovernmentSkill = UIAllianceGovernmentSkill}
