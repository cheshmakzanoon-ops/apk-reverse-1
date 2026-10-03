local CampSelfScienceInfo = BaseClass("CampSelfScienceInfo")

function CampSelfScienceInfo:__init()
  self.uuid = 0
  self.uid = 0
  self.timePoint = 0
  self.num = 0
end

function CampSelfScienceInfo:__delete()
  self.uuid = nil
  self.uid = nil
  self.timePoint = nil
  self.num = nil
end

function CampSelfScienceInfo:ParseServer(message)
  if message == nil then
    return
  end
  if message.timePoint then
    self.timePoint = message.timePoint
  end
  if message.useNum then
    self.num = self:GetAllDonateCount() - message.useNum
  end
  self.uuid = message.uuid or 0
  self.uid = message.uid or 0
end

function CampSelfScienceInfo:GetAllDonateCount()
  local groupId = DataCenter.CampScienceDataManager:GetCampScienceGroupId()
  local groupConfig = DataCenter.CampScienceTemplateManager:GetCampScienceGroup(groupId)
  return tonumber(groupConfig.donate_total_cap)
end

function CampSelfScienceInfo:GetRefreshTime()
  local groupId = DataCenter.CampScienceDataManager:GetCampScienceGroupId()
  local groupConfig = DataCenter.CampScienceTemplateManager:GetCampScienceGroup(groupId)
  return tonumber(groupConfig.donate_daily_recover_times) * 1000
end

function CampSelfScienceInfo:CanDonate()
  return true
end

function CampSelfScienceInfo:IsMaxDonateCount()
  local allCount = self:GetAllDonateCount()
  if self.num then
    return allCount == self.num
  end
  return false
end

return CampSelfScienceInfo
