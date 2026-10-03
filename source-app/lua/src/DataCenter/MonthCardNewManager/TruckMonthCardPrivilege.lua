local TruckMonthCardPrivilege = BaseClass("TruckMonthCardPrivilege")

function TruckMonthCardPrivilege:__init()
  self.freeTimes = nil
  self.vipTimes = nil
  self.freeReward = {}
  self.vipReward = {}
  self.activityId = nil
  self.hasFreeReward = false
  self.hasExtraReward = false
  self.logCount = 0
end

function TruckMonthCardPrivilege:__delete()
  self.freeTimes = nil
  self.vipTimes = nil
  self.freeReward = {}
  self.vipReward = {}
  self.activityId = nil
  self.hasFreeReward = false
  self.hasExtraReward = false
  self.logCount = 0
end

function TruckMonthCardPrivilege:ParseData(message)
  if not message then
    return
  end
  if message.freeTimes then
    self.freeTimes = message.freeTimes
  end
  if message.vipTimes then
    self.vipTimes = message.vipTimes
  end
  if message.freeReward then
    self.freeReward = message.freeReward
  end
  if message.vipReward then
    self.vipReward = message.vipReward
  end
  if message.activityId then
    self.activityId = message.activityId
  end
  self.hasFreeReward = message.hasFreeReward
  self.hasExtraReward = message.hasExtraReward
  if message.logCount then
    self.logCount = message.logCount
  end
end

function TruckMonthCardPrivilege:GetFreeReward()
  return self.freeReward or {}
end

function TruckMonthCardPrivilege:GetVipReward()
  return self.vipReward or {}
end

function TruckMonthCardPrivilege:GetFreeTimes()
  return self.freeTimes or 0
end

function TruckMonthCardPrivilege:GetVipTimes()
  return self.vipTimes or 0
end

function TruckMonthCardPrivilege:GetHasFreeReward()
  return self.hasFreeReward
end

function TruckMonthCardPrivilege:GetHasExtraReward()
  return self.hasExtraReward
end

function TruckMonthCardPrivilege:GetLogCount()
  return self.logCount
end

return TruckMonthCardPrivilege
