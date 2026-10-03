local ActivityVisitorData = BaseClass("CallerData")

function ActivityVisitorData:__init()
  self.startTime = 0
  self.endTime = 0
  self.rewardState = 0
  self.lastUpdateDataTime = 0
  self.eventId = 0
  self.nextResetTime = 0
  self.activityId = 0
  self.updateDataTimer = nil
  self.endTimeTimer = nil
end

function ActivityVisitorData:__delete()
  self.startTime = nil
  self.endTime = nil
  self.rewardState = nil
  self.lastUpdateDataTime = nil
  self.eventId = nil
  self.nextResetTime = nil
  self.activityId = nil
  self:StopAllTimer()
end

function ActivityVisitorData:UpdateData(activityId, data)
  self.activityId = activityId
  self.startTime = data.sTime
  self.endTime = data.eTime
  self.rewardState = data.rewardState
  self.lastUpdateDataTime = data.lpTime
  self.eventId = data.eventId
  self.nextResetTime = data.nextResetTime
  self:ReStartUpdateTimer()
end

function ActivityVisitorData:UpdateDataOnReceiveReward(nextResetTime)
  self.rewardState = 1
  self.nextResetTime = nextResetTime
  self:ReStartUpdateTimer()
end

function ActivityVisitorData:ReStartUpdateTimer()
  self:StopAllTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  local remainNextResetTime = math.max(self.nextResetTime - curTime, 0)
  self.updateDataTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
    self.rewardState = 0
    EventManager:GetInstance():Broadcast(EventId.ActivityVisitorDataUpdate)
  end, remainNextResetTime)
  local remainEndTime = math.max(self.endTime - curTime, 0)
  self.endTimeTimer = TimerManager:GetInstance():DelayInvokeUnscaled(function()
    EventManager:GetInstance():Broadcast(EventId.ActivityVisitorDataUpdate)
  end, remainEndTime)
  if self.tmpTimer then
    self.tmpTimer:Stop()
  end
end

function ActivityVisitorData:StopAllTimer()
  if self.updateDataTimer then
    self.updateDataTimer:Stop()
    self.updateDataTimer = nil
  end
  if self.endTimeTimer then
    self.endTimeTimer:Stop()
    self.endTimeTimer = nil
  end
end

function ActivityVisitorData:IsExpired()
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  if curTime >= self.endTime or self.rewardState == 1 then
    return true
  end
  return false
end

return ActivityVisitorData
