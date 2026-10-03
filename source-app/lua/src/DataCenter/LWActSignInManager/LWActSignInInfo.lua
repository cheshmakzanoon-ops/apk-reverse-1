local LWActSignInInfo = BaseClass("LWActSignInInfo")

function LWActSignInInfo:__init()
  self.activityId = 0
  self.dayArr = {}
  self.startTime = 0
  self.endTime = 0
  self.endViewTime = 0
end

function LWActSignInInfo:__delete()
  self.activityId = nil
  self.dayArr = nil
end

function LWActSignInInfo:UpdateData(data)
  if data.id then
    self.activityId = tonumber(data.id)
  end
  if data.dayArr then
    self.dayArr = data.dayArr
    for i = 1, #self.dayArr do
      self.dayArr[i].showReward = DataCenter.RewardManager:ReturnRewardParamForView(self.dayArr[i].reward)
    end
  end
  if data.startTime then
    self.startTime = data.startTime
  end
  if data.endTime then
    self.endTime = data.endTime
  end
  if data.endViewTime then
    self.endViewTime = data.endViewTime
  end
end

function LWActSignInInfo:GetActivityId()
  return self.activityId
end

function LWActSignInInfo:GetDayArr()
  return self.dayArr
end

function LWActSignInInfo:GetDayDataByIndex(index)
  return self.dayArr[index]
end

function LWActSignInInfo:GetCanClaimRewardDay()
  local nowReachDay = 0
  local now = UITimeManager:GetInstance():GetServerTime()
  local startTime = self.startTime
  nowReachDay = math.floor((now - startTime) / 86400000)
  local canClaimDays = 0
  for i, v in pairs(self.dayArr) do
    if v.state == 1 then
      canClaimDays = canClaimDays + 1
    elseif v.state == 0 and nowReachDay >= v.day - 1 then
      canClaimDays = canClaimDays + 1
    end
  end
  return canClaimDays
end

function LWActSignInInfo:IsEnd()
  if not self.endTime or not self.endViewTime then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.endViewTime then
    return true
  end
  return false
end

function LWActSignInInfo:CanClaimAtDay(day)
  local dayInfo = self.dayArr[day]
  if not dayInfo then
    return false
  end
  local dayState = dayInfo.state
  if dayState == 1 then
    return true
  end
  if dayState == 0 then
    local nowReachDay = 0
    local now = UITimeManager:GetInstance():GetServerTime()
    local startTime = self.startTime
    nowReachDay = math.floor((now - startTime) / 86400000)
    if nowReachDay >= day - 1 then
      return true
    end
  end
  return false
end

return LWActSignInInfo
