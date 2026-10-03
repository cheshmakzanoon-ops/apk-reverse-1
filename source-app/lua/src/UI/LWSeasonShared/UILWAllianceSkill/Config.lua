local UILWAllianceSkill = {
  Name = UIWindowNames.UILWAllianceSkill,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UILWAllianceSkill.Controller.UILWAllianceSkillCtrl"),
  View = require("UI.LWSeasonShared.UILWAllianceSkill.View.UILWAllianceSkillView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/FactionDeclareWar/UIAllianceSkill.prefab"
}
return {UILWAllianceSkill = UILWAllianceSkill}
