local MultiRewardInfo = BaseClass("MultiRewardInfo")
local ActivityMultipleConfigTemplate = require("DataCenter/MultiRewardDropManager/ActivityMultipleConfigTemplate")

function MultiRewardInfo:__init()
  self.sourceActId = 0
  self.multiConfigId = 0
  self.multiVal = 0
  self.startTime = 0
  self.enjoyEndTime = 0
  self.realEndTime = 0
  self.multiTemplate = nil
  self.enjoyTimeOverTimer = nil
  self.realEndTimeOverTimer = nil
end

function MultiRewardInfo:__delete()
  self.sourceActId = nil
  self.multiConfigId = nil
  self.multiVal = nil
  self.startTime = nil
  self.enjoyEndTime = nil
  self.realEndTime = nil
  self.multiTemplate = nil
  self:StopAllTimer()
end

function MultiRewardInfo:UpdateData(activityId, multiConfigId, multiVal, timeInfo)
  self:StopAllTimer()
  self.sourceActId = activityId or 0
  self.multiConfigId = multiConfigId or 0
  self.multiVal = multiVal or 1
  self.startTime = timeInfo.startTime or 0
  self.enjoyEndTime = timeInfo.enjoyEndTime or 0
  self.realEndTime = timeInfo.realEndTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  local enjoyRemainTime = self.enjoyEndTime - curTime
  local realEndTimeRemainTime = self.realEndTime - curTime
  if 0 < enjoyRemainTime then
    self.enjoyTimeOverTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
      EventManager:GetInstance():Broadcast(EventId.MultiRewardDataUpdate)
    end, enjoyRemainTime)
  end
  if 0 < realEndTimeRemainTime then
    self.realEndTimeOverTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
      EventManager:GetInstance():Broadcast(EventId.MultiRewardDataUpdate)
    end, realEndTimeRemainTime)
  end
end

function MultiRewardInfo:StopAllTimer()
  if self.enjoyTimeOverTimer then
    self.enjoyTimeOverTimer:Stop()
    self.enjoyTimeOverTimer = nil
  end
  if self.realEndTimeOverTimer then
    self.realEndTimeOverTimer:Stop()
    self.realEndTimeOverTimer = nil
  end
end

function MultiRewardInfo:GetMultiRewardTemplate()
  if not self.multiTemplate then
    self.multiTemplate = ActivityMultipleConfigTemplate.New()
    local lineData = LocalController:instance():getLine(TableName.DOUBLE_DROP, self.multiConfigId)
    self.multiTemplate:UpdateData(lineData)
  end
  return self.multiTemplate
end

function MultiRewardInfo:GetRewardType()
  local tmp = self:GetMultiRewardTemplate()
  if not tmp then
    return nil
  end
  return tmp.type
end

function MultiRewardInfo:IsCurCanEnjoyMultiReward()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return self:IsTargetTimeCanEnjoyMultiReward(curTime)
end

function MultiRewardInfo:IsTargetTimeCanEnjoyMultiReward(targetTime)
  return targetTime >= self.startTime and targetTime <= self.enjoyEndTime
end

function MultiRewardInfo:IsCurExpired()
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  return self:IsExpired(curTime)
end

function MultiRewardInfo:IsExpired(targetTime)
  targetTime = targetTime or UITimeManager:GetInstance():GetServerTime()
  return targetTime < self.startTime or targetTime > self.enjoyEndTime
end

function MultiRewardInfo:GetOrder()
  local tmp = self:GetMultiRewardTemplate()
  if not tmp then
    return nil
  end
  return tmp.order or 0
end

return MultiRewardInfo
