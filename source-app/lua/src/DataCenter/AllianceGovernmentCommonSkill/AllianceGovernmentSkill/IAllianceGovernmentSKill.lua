local IAllianceGovernmentSKill = BaseClass("IAllianceGovernmentSKill")

function IAllianceGovernmentSKill:__init(data)
  self.data = data
  self.pointId = nil
  self.targetUuid = nil
  self.extra = nil
  self:Init()
end

function IAllianceGovernmentSKill:__delete()
  self:Clear()
  self.data = nil
  self.pointId = nil
  self.targetUuid = nil
  self.extra = nil
end

function IAllianceGovernmentSKill:Init()
end

function IAllianceGovernmentSKill:Clear()
end

function IAllianceGovernmentSKill:DoPreUse()
  if self:CanUse() then
    self:PreUse()
  end
end

function IAllianceGovernmentSKill:CanUse()
  local canUseOfficial = self:GetCanUseOfficialType()
  if self.data:IsLock() then
    UIUtil.ShowTipsId("season_s6_government_skill_error_tips05")
    return false
  end
  if canUseOfficial ~= nil then
    local officialPos = DataCenter.AllianceGovernmentSkillManager:GetOfficialPosByUid(LuaEntry.Player.uid)
    if self:GetCanUseOfficialType() == LWAlMemberOffcialType.Al_MASTER then
      if not DataCenter.AllianceBaseDataManager:IsR5() then
        UIUtil.ShowTipsId("season_s6_government_skill_error_tips02")
        return false
      end
    elseif self:GetCanUseOfficialType() ~= officialPos then
      UIUtil.ShowTipsId("season_s6_government_skill_error_tips02")
      return false
    end
  end
  local inCd = self.data:InCd()
  if inCd then
    UIUtil.ShowTipsId("season_s6_government_skill_error_tips03")
    return false
  end
  if not self.data:IsEnoughEnergy() then
    UIUtil.ShowTipsId("season_s6_government_skill_error_tips04")
    return false
  end
  return true
end

function IAllianceGovernmentSKill:GetCanUseOfficialType()
end

function IAllianceGovernmentSKill:PreUse()
end

function IAllianceGovernmentSKill:Use()
  self:SendMessage()
end

function IAllianceGovernmentSKill:SendMessage()
  local skillId = self.data.config.id
  SFSNetwork.SendMessage(MsgDefines.UseAllianceOfficialSkill, skillId, self.pointId or 0, self.worldId or 0, self.targetUuid or 0)
end

function IAllianceGovernmentSKill:GetUseTipInfo()
end

function IAllianceGovernmentSKill:BindParam(pointId, worldId, targetUuid)
  self.pointId = pointId or 0
  self.worldId = worldId or 0
  self.targetUuid = targetUuid or 0
end

function IAllianceGovernmentSKill:BindExtra(extra)
  self.extra = extra
end

return IAllianceGovernmentSKill
