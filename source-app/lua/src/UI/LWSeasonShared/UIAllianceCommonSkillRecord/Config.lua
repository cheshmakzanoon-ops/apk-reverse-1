local UIAllianceCommonSkillRecord = {
  Name = UIWindowNames.UIAllianceCommonSkillRecord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UIAllianceCommonSkillRecord.Controller.UIAllianceCommonSkillRecordCtrl"),
  View = require("UI.LWSeasonShared.UIAllianceCommonSkillRecord.View.UIAllianceCommonSkillRecordView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/UIAllianceCommonSkillRecord.prefab"
}
return {UIAllianceCommonSkillRecord = UIAllianceCommonSkillRecord}
