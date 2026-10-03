local SkillChargeData = BaseClass("SkillChargeData")
local CDType = {
  ByTime = 1,
  ByDay = 2,
  Never = 3,
  Werewolf = 4,
  ByWeek = 5
}

function SkillChargeData:__init(serverData)
  self:ParseServerData(serverData)
end

function SkillChargeData:__delete()
  self.num = nil
  self.max = nil
  self.lastUseTime = nil
  self.lastTime = nil
  self.duration = nil
  self.type = nil
end

function SkillChargeData:ParseServerData(serverData)
  if serverData.num then
    self.num = serverData.num
  end
  if serverData.max then
    self.max = serverData.max
  end
  if serverData.lastUseTime then
    self.lastUseTime = serverData.lastUseTime
  end
  if serverData.lastTime then
    self.lastTime = serverData.lastTime
  end
  if serverData.duration then
    self.duration = serverData.duration
  end
  if serverData.type then
    self.type = serverData.type
  end
end

function SkillChargeData:IsRealChargeSkill()
  return self.max > 1
end

function SkillChargeData:GetLastUseTime()
  return self.lastUseTime or 0
end

function SkillChargeData:GetAvailableTime()
  if self.num > 0 then
    return 0
  end
  if self.type == CDType.ByTime then
    return self.lastTime + self.duration
  elseif self.type == CDType.ByDay then
    return UITimeManager:GetInstance():GetNextZero(self.lastTime)
  elseif self.type == CDType.ByWeek then
    return UITimeManager:GetInstance():GetNextWeekDay(1, self.lastTime)
  elseif self.type == CDType.Never then
    return MANY_YEARS_LATER
  elseif self.type == CDType.Werewolf then
    if DataCenter.SeasonHunterManager:IsInBattle() then
      return self.lastTime + self.duration
    else
      return MANY_YEARS_LATER
    end
  end
end

function SkillChargeData:GetCurAndMaxCount()
  local cur = self.num
  local max = self.max
  if cur == max then
    return cur, max
  end
  local cd = self.duration
  local lastTime = self.lastTime
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.type == CDType.ByTime then
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
  elseif self.type == CDType.ByDay then
    local nextDayZero = UITimeManager:GetInstance():GetNextZero(lastTime)
    if now < nextDayZero then
      return cur, max, nextDayZero
    else
      return max, max
    end
  elseif self.type == CDType.ByWeek then
    local nextWeekZero = UITimeManager:GetInstance():GetNextWeekDay(1, lastTime)
    if now < nextWeekZero then
      return cur, max, nextWeekZero
    else
      return max, max
    end
  elseif self.type == CDType.Never then
    return cur, max, MANY_YEARS_LATER
  elseif self.type == CDType.Werewolf then
    if DataCenter.SeasonHunterManager:IsInBattle() then
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
    else
      return 0, max, MANY_YEARS_LATER
    end
  end
end

return SkillChargeData
