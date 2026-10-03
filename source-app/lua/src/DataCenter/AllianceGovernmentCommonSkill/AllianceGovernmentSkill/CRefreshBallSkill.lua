local IAllianceGovernmentSKill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.IAllianceGovernmentSKill")
local base = IAllianceGovernmentSKill
local CRefreshBallSkill = BaseClass("CRefreshBallSkill", IAllianceGovernmentSKill)
local UICRefreshBallSkillTipItem = require("UI.LWSeasonShared.UIAllianceCommonSkillUseTip.Component.UICRefreshBallSkillTipItem")

function CRefreshBallSkill:CanUse()
  if not base.CanUse(self) then
    return false
  end
  local allSkillList = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillList(AlOfficialSkillType.RefreshBall)
  for _, v in pairs(allSkillList) do
    if v:InCd() then
      return true
    end
  end
  UIUtil.ShowTipsId("season_s6_government_skill_error_tips01")
  return false
end

function CRefreshBallSkill:PreUse()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCommonSkillSelect, {anim = true}, self.data)
end

function CRefreshBallSkill:GetCanUseOfficialType()
  return LWAlMemberOffcialType.Al_MASTER
end

function CRefreshBallSkill:GetUseTipInfo()
  return {
    prefab = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/Component/ItemSkill_RefreshBall.prefab",
    classPath = UICRefreshBallSkillTipItem
  }
end

function CRefreshBallSkill:Use()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCommonSkillUseTip, {anim = true}, self, self.data)
end

function CRefreshBallSkill:SendMessage()
  self.targetUuid = self.extra.config.id
  base.SendMessage(self)
end

return CRefreshBallSkill
