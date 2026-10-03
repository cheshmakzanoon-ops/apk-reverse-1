local WorldChargeData = BaseClass("WorldChargeData")

function WorldChargeData:__init()
  self.indexDic = nil
  self.chargeStartTime = 0
  self.chargeEndTime = 0
  self.alreadyCharge = 0
  self.battery = 0
end

function WorldChargeData:__delete()
end

function WorldChargeData:ParseData(message)
  self:ParseIndex(message.indexArray)
  if message.chargeStartTime then
    self.chargeStartTime = message.chargeStartTime
  end
  if message.chargeEndTime then
    self.chargeEndTime = message.chargeEndTime
  end
  if message.alreadyCharge then
    self.alreadyCharge = message.alreadyCharge
  end
  if message.battery then
    self.battery = message.battery
  end
end

function WorldChargeData:ParseIndex(indexArray)
  if not indexArray then
    return
  end
  self.indexDic = {}
  for i, v in ipairs(indexArray) do
    v.index = v.index + 1
    self.indexDic[v.index] = v
  end
end

function WorldChargeData:GetPlayerByIndex(index)
  return self.indexDic and self.indexDic[index]
end

function WorldChargeData:GetPercent()
  local curPercent = self.alreadyCharge / self.battery
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local startTime = self.chargeStartTime
  local endTime = self.chargeEndTime
  if startTime and endTime then
    if curTime > startTime and curTime < endTime then
      curPercent = curPercent + (curTime - startTime) / (endTime - startTime) * (1 - curPercent)
    elseif 0 < endTime and curTime >= endTime then
      curPercent = 1
    end
  end
  return curPercent
end

function WorldChargeData:IsCharging()
  if self.chargeEndTime <= 0 then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.chargeStartTime and curTime < self.chargeEndTime then
    return true
  end
  return false
end

function WorldChargeData:HasPlayer(uid)
  if not self.indexDic then
    return false
  end
  for i, v in pairs(self.indexDic) do
    if v.uid == uid then
      return true
    end
  end
  return false
end

function WorldChargeData:GetPlayerCount()
  if not self.indexDic then
    return 0
  end
  local count = 0
  for i, v in pairs(self.indexDic) do
    if v.getReward == 1 then
      count = count + 1
    end
  end
  return count
end

return WorldChargeData
