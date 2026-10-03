local BuildQueueInfo = BaseClass("BuildQueueInfo")

local function __init(self)
  self.uuid = 0
  self.order = 0
  self.expireTime = 0
  self.occupyData = nil
  self.occupyUuid = 0
  self.id = 0
  self.template = nil
  self.type = 0
  self.unlock = false
  self.giftId = 0
  self.rent_price = 0
  self.rent_time = 0
end

local function __delete(self)
  self.uuid = 0
  self.order = 0
  self.expireTime = 0
  self.occupyData = nil
  self.occupyUuid = 0
  self.id = 0
  self.template = nil
  self.type = 0
  self.unlock = false
  self.giftId = 0
  self.rent_price = 0
  self.rent_time = 0
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.expireTime ~= nil then
    self.expireTime = message.expireTime
  end
  if message.itemObj ~= nil then
    self.occupyData = message.itemObj
    if not table.IsNullOrEmpty(self.occupyData) then
      self.occupyUuid = tonumber(self.occupyData.itemId)
    else
      self.occupyUuid = 0
    end
  else
    self.occupyData = nil
    self.occupyUuid = 0
  end
  if message.qid ~= nil then
    self.id = message.qid
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.unlock ~= nil then
    self.unlock = message.unlock == 1
  end
  if message.gift ~= nil then
    self.giftId = message.gift
  end
  if message.rentPrice ~= nil then
    self.rent_price = message.rentPrice
  end
  if message.rentTime ~= nil then
    self.rent_time = message.rentTime
  end
  self.template = DataCenter.BuildQueueTemplateManager:GetBuildQueueTemplate(self.id)
  self.order = 0
  if self.template then
    self.order = self.template.order
  end
end

local function ResetQueue(self)
  self.occupyUuid = 0
end

local function IsConstructing(self)
  return self.occupyUuid and self.occupyUuid > 0
end

local function IsFinish(self)
  if not self:IsConstructing() then
    return true
  else
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.occupyUuid)
    if buildData then
      if buildData:IsUpgradeFinish() then
        return true
      else
        return false
      end
    else
      return false
    end
  end
end

local function IsFreeQueueToUse(self)
  if not self:CanUse() then
    return false
  end
  return self:IsFinish()
end

local function IsFreeQueue(self)
  if self:IsConstructing() then
    return self:IsFinish()
  end
  return true
end

local function IsExpired(self)
  if self.expireTime <= 0 then
    return false
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.expireTime then
      return true
    else
      return false
    end
  end
end

local function IsRentQueue(self)
  return self.expireTime > 0
end

local function IsSpecialQueue(self)
  return self.type == LWBuildQueueType.SPECIAL
end

local function CanUse(self)
  if self.type == LWBuildQueueType.NORMAL then
    if self.unlock then
      return not self:IsExpired()
    else
      return false
    end
  elseif self.type == LWBuildQueueType.SPECIAL then
    return false
  else
    return true
  end
end

local function IsViewLocked(self)
  if self:IsConstructing() and not self:IsFinish() then
    return false
  end
  return not self:CanUse()
end

local function IsUnlocked(self)
  return self.unlock
end

local function IsOwned(self)
  return self.unlock and self.expireTime <= 0
end

BuildQueueInfo.__init = __init
BuildQueueInfo.__delete = __delete
BuildQueueInfo.ParseData = ParseData
BuildQueueInfo.ResetQueue = ResetQueue
BuildQueueInfo.IsFinish = IsFinish
BuildQueueInfo.IsFreeQueueToUse = IsFreeQueueToUse
BuildQueueInfo.IsFreeQueue = IsFreeQueue
BuildQueueInfo.IsExpired = IsExpired
BuildQueueInfo.IsRentQueue = IsRentQueue
BuildQueueInfo.IsSpecialQueue = IsSpecialQueue
BuildQueueInfo.CanUse = CanUse
BuildQueueInfo.IsConstructing = IsConstructing
BuildQueueInfo.IsViewLocked = IsViewLocked
BuildQueueInfo.IsUnlocked = IsUnlocked
BuildQueueInfo.IsOwned = IsOwned
return BuildQueueInfo
