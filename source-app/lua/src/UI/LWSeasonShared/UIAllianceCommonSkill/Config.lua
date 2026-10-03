local UIAllianceCommonSkill = {
  Name = UIWindowNames.UIAllianceCommonSkill,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UIAllianceCommonSkill.Controller.UIAllianceCommonSkillCtrl"),
  View = require("UI.LWSeasonShared.UIAllianceCommonSkill.View.UIAllianceCommonSkillView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/UIAllianceCommonSkill.prefab"
}
return {UIAllianceCommonSkill = UIAllianceCommonSkill}
