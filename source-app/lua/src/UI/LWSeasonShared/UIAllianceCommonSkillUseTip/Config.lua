local UIAllianceCommonSkillUseTip = {
  Name = UIWindowNames.UIAllianceCommonSkillUseTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeasonShared.UIAllianceCommonSkillUseTip.Controller.UIAllianceCommonSkillUseTipCtrl"),
  View = require("UI.LWSeasonShared.UIAllianceCommonSkillUseTip.View.UIAllianceCommonSkillUseTipView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/UIAllianceCommonSkillUseTip.prefab"
}
return {UIAllianceCommonSkillUseTip = UIAllianceCommonSkillUseTip}
