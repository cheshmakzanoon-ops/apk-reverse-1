local MailLandmineReport = BaseClass("MailLandmineReport")

function MailLandmineReport:__init()
end

function MailLandmineReport:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  self.allianceId = mailContent.allianceId
  self.prey = mailContent.prey
  self.hunter = mailContent.hunter
  self.pointId = mailContent.pointId
  self.startTime = mailContent.startTime
  self.endTime = mailContent.endTime
  self.ownerId = mailContent.ownerId
  self.cfgId = mailContent.cfgId
  self.uuid = mailContent.uuid
  self.effect = mailContent.effect
end

function MailLandmineReport:IsPassive()
  return self.prey and self.prey.uid == LuaEntry.Player.uid
end

function MailLandmineReport:IsFrozen()
  return self.effect and self.effect.isFreezing
end

function MailLandmineReport:IsFire()
  return self.effect and self.effect.isFire
end

function MailLandmineReport:IsFly()
  return self.effect and self.effect.isCityBroken
end

function MailLandmineReport:IsLightOff()
  return self.effect and self.effect.isCloseLight
end

function MailLandmineReport:GetKillData()
  return self.effect and self.effect.deadInfo or {}
end

function MailLandmineReport:GetKillCount()
  local ret = 0
  if self.effect and self.effect.deadInfo then
    for _, v in pairs(self.effect.deadInfo) do
      ret = ret + v
    end
  end
  return ret
end

return MailLandmineReport
