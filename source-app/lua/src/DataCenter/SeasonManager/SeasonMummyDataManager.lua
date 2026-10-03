local SeasonMummyDataManager = BaseClass("SeasonMummyDataManager")

function SeasonMummyDataManager:__init()
  self.maxMummyNum = 0
  self.armyArr = nil
  self.waitConvertArmyList = nil
end

function SeasonMummyDataManager:__delete()
end

function SeasonMummyDataManager:GetWaitConvertArmyCount()
  local armyCount = 0
  local theDeathSoldierInfo = self.waitConvertArmyList
  if theDeathSoldierInfo then
    for k, v in pairs(theDeathSoldierInfo) do
      armyCount = armyCount + v.armyNum
    end
  end
  return armyCount
end

function SeasonMummyDataManager:UpdateRecArmy(list)
  self.armyArr = list
  EventManager:GetInstance():Broadcast(EventId.UpdateSeasonDeathSoldierInfo)
end

function SeasonMummyDataManager:GetArmy()
  return self.armyArr
end

function SeasonMummyDataManager:HasArmy()
  return not table.IsNullOrEmpty(self.armyArr)
end

function SeasonMummyDataManager:GetArmyCount(armyArr)
  armyArr = armyArr or self.armyArr
  if not armyArr then
    return 0
  end
  local count, maxData = 0
  for i, v in pairs(armyArr) do
    count = count + (v.armyNum or 0)
    if maxData == nil or maxData.armyNum < v.armyNum then
      maxData = v
    end
  end
  return count, maxData
end

return SeasonMummyDataManager
