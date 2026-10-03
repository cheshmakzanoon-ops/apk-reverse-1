local EarthOrderInfo = BaseClass("EarthOrderInfo")

local function __init(self)
  self.uuid = 0
  self.expTime = 0
  self.orderItemArr = {}
  self.filledItemArr = {}
  self.needResourceItems = {}
  self.status = RocketStatus.RocketStatus_Normal
end

local function __delete(self)
  self.uuid = nil
  self.expTime = nil
  self.orderItemArr = nil
  self.filledItemArr = nil
  self.status = nil
  self.needResourceItems = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.expireTime ~= nil then
    self.expTime = message.expireTime
  end
  if message.orderItemArr ~= nil then
    self.orderItemArr = message.orderItemArr
  end
  if message.filledItemArr ~= nil then
    self.filledItemArr = message.filledItemArr
  end
  if message.addReward ~= nil then
    self.addReward = message.addReward
  end
  self.status = message.status or RocketStatus.RocketStatus_Normal
end

local function IsSubmit(self, id, index)
  for k, v in pairs(self.filledItemArr) do
    local rocketOrderItem = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Rocket_Order), tostring(v.orderId))
    if index == tonumber(v.index + 1) and id == tonumber(rocketOrderItem.product_id) then
      return true
    end
  end
  return false
end

local function GetNeedItem(self)
  self.needResourceItems = {}
  for k, v in pairs(self.orderItemArr) do
    local rocketOrderItem = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Rocket_Order), tostring(v.orderId))
    if rocketOrderItem.product_id ~= nil then
      local need = {}
      need.needId = tonumber(rocketOrderItem.product_id)
      need.count = tonumber(rocketOrderItem.product_num)
      need.money = tonumber(rocketOrderItem.money)
      need.rewardList = v.rewardArr
      table.insert(self.needResourceItems, need)
    end
  end
  return self.needResourceItems
end

EarthOrderInfo.__init = __init
EarthOrderInfo.__delete = __delete
EarthOrderInfo.ParseData = ParseData
EarthOrderInfo.IsSubmit = IsSubmit
EarthOrderInfo.GetNeedItem = GetNeedItem
return EarthOrderInfo
