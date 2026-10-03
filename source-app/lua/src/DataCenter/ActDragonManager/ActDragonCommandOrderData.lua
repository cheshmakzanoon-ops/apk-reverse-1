local ActDragonCommandOrderData = BaseClass("ActDragonCommandOrderData")

function ActDragonCommandOrderData:__init()
  self.index = 0
  self.type = 0
  self.point = 0
  self.commander = ""
  self.joinCount = 0
  self.hadJoin = false
  self.time = 0
  self.extra = ""
  self.bNew = false
end

function ActDragonCommandOrderData:__delete()
  self:ResetData()
end

function ActDragonCommandOrderData:ResetData()
  self.index = 0
  self.type = 0
  self.point = 0
  self.commander = ""
  self.joinCount = 0
  self.hadJoin = false
  self.time = 0
  self.extra = ""
  self.bNew = false
end

function ActDragonCommandOrderData:ParseData(message)
  if message == nil then
    return
  end
  if message.index ~= nil then
    self.index = message.index
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.point ~= nil then
    self.point = message.point
  end
  if message.commander ~= nil then
    self.commander = message.commander
  end
  if message.joinCount ~= nil then
    self.joinCount = message.joinCount
  end
  if message.hadJoin ~= nil then
    self.hadJoin = message.hadJoin
  end
  if message.time ~= nil then
    self.time = message.time
  end
  if message.extra ~= nil then
    self.extra = message.extra
  end
end

function ActDragonCommandOrderData:CopyOrder(order)
  if order == nil then
    self:ResetData()
    return
  end
  self.index = order.index
  self.type = order.type
  self.point = order.point
  self.commander = order.commander
  self.joinCount = order.joinCount
  self.hadJoin = order.hadJoin
  self.time = order.time
  self.extra = order.extra
end

function ActDragonCommandOrderData:IsSame(order)
  if order == nil then
    return false
  end
  if order.commander ~= self.commander then
    return false
  end
  if order.point ~= self.point then
    return false
  end
  if order.type ~= self.type then
    return false
  end
  if order.time ~= self.time then
    return false
  end
  return true
end

return ActDragonCommandOrderData
