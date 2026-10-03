local UIAllianceGovernmentSkillHistory = {
  Name = UIWindowNames.UIAllianceGovernmentSkillHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceGovernmentSkill.SkillHistory.Controller.UIAllianceGovernmentSkillHistoryCtrl"),
  View = require("UI.UIAlliance.UIAllianceGovernmentSkill.SkillHistory.View.UIAllianceGovernmentSkillHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/GovernmentSkillHistory.prefab"
}
return {UIAllianceGovernmentSkillHistory = UIAllianceGovernmentSkillHistory}
