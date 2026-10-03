local BattlefieldDsbSoldierData = BaseClass("BattlefieldDsbSoldierData")

function BattlefieldDsbSoldierData:__init()
  self.armyId = 0
  self.finishNum = 0
  self.needCureNum = 0
  self.deadTotal = 0
end

function BattlefieldDsbSoldierData:__delete()
  self.armyId = nil
  self.finishNum = nil
  self.needCureNum = nil
  self.deadTotal = nil
end

function BattlefieldDsbSoldierData:ParseData(message)
  if message.armyId then
    self.armyId = tonumber(message.armyId)
  end
  if message.autoHeal then
    self.needCureNum = message.autoHeal
  end
  if message.dead then
    self.deadTotal = message.dead
  end
  if message.heal then
    self.finishNum = message.heal
  end
end

return BattlefieldDsbSoldierData
