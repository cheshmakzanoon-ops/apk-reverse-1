local UIAllianceGovernmentSkillHurtList = {
  Name = UIWindowNames.UIAllianceGovernmentSkillHurtList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceGovernmentSkill.SkillHurtList.Controller.UIAllianceGovernmentSkillHurtListCtrl"),
  View = require("UI.UIAlliance.UIAllianceGovernmentSkill.SkillHurtList.View.UIAllianceGovernmentSkillHurtListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/GovernmentSkillHurtList.prefab"
}
return {UIAllianceGovernmentSkillHurtList = UIAllianceGovernmentSkillHurtList}
