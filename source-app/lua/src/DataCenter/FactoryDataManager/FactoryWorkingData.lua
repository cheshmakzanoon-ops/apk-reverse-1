local FactoryWorkingData = BaseClass("FactoryWorkingData")

local function __init(self)
  self.product = 0
  self.startTime = 0
  self.endTime = 0
  self.stopTime = 0
  self.index = 0
end

local function __delete(self)
  self.product = nil
  self.startTime = nil
  self.endTime = nil
  self.stopTime = nil
  self.index = nil
end

local function RefreshData(self, message)
  if message.product ~= nil then
    self.product = message.product
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.stopTime ~= nil then
    self.stopTime = message.stopTime
  end
  if message.index ~= nil then
    self.index = message.index
  end
end

FactoryWorkingData.__init = __init
FactoryWorkingData.__delete = __delete
FactoryWorkingData.RefreshData = RefreshData
return FactoryWorkingData
