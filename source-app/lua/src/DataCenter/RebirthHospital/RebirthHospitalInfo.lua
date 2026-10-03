local RebirthHospitalInfo = BaseClass("RebirthHospitalInfo")

function RebirthHospitalInfo:__init()
  self.armyId = 0
  self.dead = 0
  self.rebirth = 0
end

function RebirthHospitalInfo:__delete()
  self.armyId = nil
  self.heal = nil
  self.rebirth = nil
end

function RebirthHospitalInfo:UpdateInfo(message)
  if message == nil then
    return
  end
  if message.armyId ~= nil then
    self.armyId = tonumber(message.armyId)
  end
  if message.rebirth ~= nil then
    self.rebirth = message.rebirth
  end
  if message.dead ~= nil then
    self.dead = message.dead
  end
end

function RebirthHospitalInfo:GetDeadCount()
  return self.dead or 0
end

function RebirthHospitalInfo:GetRebirthCount()
  return self.rebirth or 0
end

function RebirthHospitalInfo:GetSoldierTemplate()
  if self.armyId ~= nil then
    return DataCenter.SoldierDataManager:GetTemplate(self.armyId)
  end
end

function RebirthHospitalInfo:GetSoldierRebirthResourceCost(count)
  local soldierTemplate = self:GetSoldierTemplate()
  local res = {}
  if soldierTemplate ~= nil and not table.IsNullOrEmpty(soldierTemplate.rebirthCost) then
    for i, v in pairs(soldierTemplate.rebirthCost) do
      res[i] = v * count
    end
  end
  return res
end

function RebirthHospitalInfo:GetSoldierRebirthTimeCost(count)
  local soldierTemplate = self:GetSoldierTemplate()
  local res = 0
  if soldierTemplate ~= nil and 0 < soldierTemplate.rebirthTime then
    res = soldierTemplate.rebirthTime * count
  end
  return res
end

function RebirthHospitalInfo:GetCurRebirthProgress()
  if self:GetRebirthCount() > 0 then
    local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.RebirthHospital)
    if queue ~= nil then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local passedTime = curTime - queue.startTime
      local totalTime = queue.endTime - queue.startTime
      if totalTime ~= 0 then
        local percent = math.min(1, passedTime / totalTime)
        return math.max(0, math.floor(self:GetRebirthCount() * percent))
      else
        return self:GetRebirthCount()
      end
    end
  end
  return 0
end

return RebirthHospitalInfo
