local ActDragonSoldierData = BaseClass("ActDragonSoldierData")

function ActDragonSoldierData:__init()
  self.armyId = 0
  self.finishNum = 0
  self.needCureNum = 0
  self.deadTotal = 0
end

function ActDragonSoldierData:__delete()
  self.armyId = nil
  self.finishNum = nil
  self.needCureNum = nil
  self.deadTotal = nil
end

function ActDragonSoldierData:ParseData(message)
  if message.armyId then
    self.armyId = tonumber(message.armyId)
  end
  if message.finishNum then
    self.finishNum = message.finishNum
  end
  if message.needCureNum then
    self.needCureNum = message.needCureNum
  end
  if message.deadTotal then
    self.deadTotal = message.deadTotal
  end
end

return ActDragonSoldierData
