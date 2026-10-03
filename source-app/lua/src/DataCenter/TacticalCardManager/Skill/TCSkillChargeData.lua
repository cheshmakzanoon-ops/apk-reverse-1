local TCSkillChargeData = BaseClass("TCSkillChargeData")
local CDType = {RecoverOneByTime = 1, RecoverAllByXDay = 2}

function TCSkillChargeData:__init()
  self.num = 0
  self.max = 0
  self.lastUseTime = 0
  self.lastTime = 0
  self.cdValue = 0
  self.type = CDType.RecoverOneByTime
  self.recoverFullTime = 0
end

function TCSkillChargeData:__delete()
  self.num = nil
  self.max = nil
  self.lastUseTime = nil
  self.lastTime = nil
  self.cdValue = nil
  self.type = nil
  self.recoverFullTime = 0
end

function TCSkillChargeData:UpdateData(serverData)
  if not serverData then
    Logger.LogError("serverData is null.")
    return
  end
  if serverData.num then
    self.num = serverData.num
  end
  if serverData.max then
    self.max = serverData.max
  end
  if serverData.type then
    self.type = serverData.type
  end
  if serverData.lastTime then
    self.lastTime = serverData.lastTime
  end
  if serverData.cdValue then
    self.cdValue = serverData.cdValue
  end
  if serverData.recoverFullTime then
    self.recoverFullTime = serverData.recoverFullTime
  end
end

function TCSkillChargeData:IsRealChargeSkill()
  return self.max > 1
end

function TCSkillChargeData:GetAvailableTime()
  if self.num > 0 then
    return 0
  end
  if self.type == CDType.RecoverOneByTime then
    return self.lastTime + self.cdValue * 1000
  elseif self.type == CDType.RecoverAllByXDay then
    return self.recoverFullTime
  end
end

function TCSkillChargeData:GetOnceCD()
  if self.type == CDType.RecoverOneByTime then
    return self.cdValue * 1000
  elseif self.type == CDType.RecoverAllByXDay then
    return self.cdValue * 24 * 60 * 60 * 1000
  end
end

function TCSkillChargeData:GetCurAndMaxCount()
  local cur = self.num
  local max = self.max
  if cur == max then
    return cur, max
  end
  local cd = self.cdValue * 1000
  local lastTime = self.lastTime
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.type == CDType.RecoverOneByTime then
    if lastTime >= now then
      return cur, max, lastTime + cd
    end
    local add = (now - lastTime) // cd
    cur = math.min(max, cur + add)
    if cur == max then
      return cur, max
    else
      return cur, max, lastTime + cd * (add + 1)
    end
  elseif self.type == CDType.RecoverAllByXDay then
    local nextDayZero = self.recoverFullTime
    if now < nextDayZero then
      return cur, max, nextDayZero
    else
      return max, max
    end
  end
end

function TCSkillChargeData:GetCurChargeCount()
  local cur, max = self:GetCurAndMaxCount()
  return cur
end

function TCSkillChargeData:IsFullCharge()
  local cur, max = self:GetCurAndMaxCount()
  return max <= cur
end

return TCSkillChargeData
