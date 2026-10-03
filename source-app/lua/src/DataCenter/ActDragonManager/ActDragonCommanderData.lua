local ActDragonCommanderData = BaseClass("ActDragonCommanderData")

function ActDragonCommanderData:__init()
  self.uid = ""
  self.orderCount = 0
  self.finishCount = 0
  self.joinCount = 0
  self.thumbsUpCount = 0
end

function ActDragonCommanderData:__delete()
  self.uid = ""
  self.orderCount = 0
  self.finishCount = 0
  self.joinCount = 0
  self.thumbsUpCount = 0
end

function ActDragonCommanderData:ParseData(message)
  if message == nil then
    return
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.orderCount ~= nil then
    self.orderCount = message.orderCount
  end
  if message.finishCount ~= nil then
    self.finishCount = message.finishCount
  end
  if message.joinCount ~= nil then
    self.joinCount = message.joinCount
  end
  if message.thumbsUpCount ~= nil then
    self.thumbsUpCount = message.thumbsUpCount
  end
end

return ActDragonCommanderData
