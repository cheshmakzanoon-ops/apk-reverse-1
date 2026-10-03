local ResidentOrderInfo = BaseClass("ResidentOrderInfo")
local Setting = CS.GameEntry.Setting

local function __init(self)
  self.uuid = 0
  self.expTime = 0
  self.orderId = 0
  self.index = 0
  self.state = PurchaseOrderState.NORMAL
  self.change = 0
  self.random = nil
end

local function __delete(self)
  self.uuid = nil
  self.expTime = nil
  self.orderId = nil
  self.index = nil
  self.state = PurchaseOrderState.NORMAL
  self.change = nil
  self.random = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.refreshTime ~= nil then
    self.expTime = message.refreshTime
  end
  if message.orderId ~= nil then
    self.orderId = message.orderId
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.index ~= nil then
    self.index = message.index
  end
  if message.randomValue ~= nil then
    self.random = message.randomValue
  end
  local state = Setting:GetString(LuaEntry.Player.uid .. "ResidentOrderState" .. self.index + 1, "-1")
  if state == "-1" then
    Setting:SetString(LuaEntry.Player.uid .. "ResidentOrderState" .. self.index + 1, self.state)
  end
  local leftTime = Setting:GetString(LuaEntry.Player.uid .. "ResidentOrder" .. self.index + 1, "0")
  if leftTime == "0" then
    Setting:SetString(LuaEntry.Player.uid .. "ResidentOrder" .. self.index + 1, self.expTime)
  end
  if message.rewardArr ~= nil then
    self.rewardArr = message.rewardArr
  else
    self.rewardArr = {}
  end
  if message.refreshTime then
    self.refreshTime = message.refreshTime
  end
end

ResidentOrderInfo.__init = __init
ResidentOrderInfo.__delete = __delete
ResidentOrderInfo.ParseData = ParseData
return ResidentOrderInfo
