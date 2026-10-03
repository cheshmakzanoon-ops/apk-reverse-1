local UIAllianceCommonSkillSelect = {
  Name = UIWindowNames.UIAllianceCommonSkillSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UIAllianceCommonSkillSelect.Controller.UIAllianceCommonSkillSelectCtrl"),
  View = require("UI.LWSeasonShared.UIAllianceCommonSkillSelect.View.UIAllianceCommonSkillSelectView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/UIAllianceCommonSkillSelect.prefab"
}
return {UIAllianceCommonSkillSelect = UIAllianceCommonSkillSelect}
