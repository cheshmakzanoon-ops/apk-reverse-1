local IAllianceGovernmentSKill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.IAllianceGovernmentSKill")
local UICAbundantHarvestSkillTipItem = require("UI.LWSeasonShared.UIAllianceCommonSkillUseTip.Component.UICAbundantHarvestSkillTipItem")
local base = IAllianceGovernmentSKill
local CAbundantHarvestSkill = BaseClass("CAbundantHarvestSkill", IAllianceGovernmentSKill)

function CAbundantHarvestSkill:PreUse()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCommonSkillUseTip, {anim = true}, self, self.data)
end

function CAbundantHarvestSkill:GetCanUseOfficialType()
  return LWAlMemberOffcialType.Al_MASTER
end

function CAbundantHarvestSkill:GetUseTipInfo()
  return {
    prefab = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/Component/ItemSkill_AbundantHarvest.prefab",
    classPath = UICAbundantHarvestSkillTipItem
  }
end

return CAbundantHarvestSkill
