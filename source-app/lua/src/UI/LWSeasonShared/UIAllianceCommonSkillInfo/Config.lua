local UIAllianceCommonSkillInfo = {
  Name = UIWindowNames.UIAllianceCommonSkillInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UIAllianceCommonSkillInfo.Controller.UIAllianceCommonSkillInfoCtrl"),
  View = require("UI.LWSeasonShared.UIAllianceCommonSkillInfo.View.UIAllianceCommonSkillInfoView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/UIAllianceCommonSkillInfo.prefab"
}
return {UIAllianceCommonSkillInfo = UIAllianceCommonSkillInfo}
