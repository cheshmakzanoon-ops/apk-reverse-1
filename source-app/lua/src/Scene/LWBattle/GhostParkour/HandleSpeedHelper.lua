local HandleSpeedHelper = BaseClass("HandleSpeedHelper")

function HandleSpeedHelper:__init(unit, baseSpeed)
  self.unit = unit
  self.baseSpeed = baseSpeed
  self.currentSpeed = 0
  self.startSpeed = 0
  self.endSpeed = 0
  self.baseTime = 0
  self.baseDistance = 0
  self.cacheDistance = 0
  self.lastAverageSpeed = 0
  self.cacheTime = 0
  self.cacheTimer = 0
  self.logStr = {}
  self.isDebug = CS.CommonUtils.IsDebug()
  self.isEditor = CS.UnityEngine.Application.isEditor
end

function HandleSpeedHelper:__delete()
  self.unit = nil
  self.baseSpeed = nil
  self.currentSpeed = nil
  self.startSpeed = nil
  self.endSpeed = nil
  self.baseTime = nil
  self.baseDistance = nil
  self.cacheDistance = nil
  self.lastAverageSpeed = nil
  self.cacheTime = nil
  self.cacheTimer = nil
  self.logStr = nil
  self.isDebug = nil
  self.isEditor = nil
end

function HandleSpeedHelper:SetMoveParam(toSpeed, totalDeltaTime, duration)
  if toSpeed == nil or toSpeed <= 0 then
    return
  end
  duration = duration or 0
  local str = ""
  if self.endSpeed == 0 then
    self.baseTime = 0
    self.baseDistance = 0
    self.startSpeed = toSpeed
    self.endSpeed = toSpeed
    self.cacheDistance = 0
    self.lastAverageSpeed = 0
    self.cacheTime = 0
    self.cacheTimer = totalDeltaTime
  else
    if toSpeed == self.endSpeed then
      return
    end
    self.startSpeed = self.endSpeed
    local offsetTime = totalDeltaTime - self.cacheTimer
    self.cacheTime = offsetTime
    local offsetDistance = 0
    if 0 < self.lastAverageSpeed then
      if offsetTime < self.changeDuration then
        offsetDistance = self.lastAverageSpeed * offsetTime
        self.cacheDistance = offsetDistance
      else
        offsetTime = offsetTime - self.changeDuration
        local lastChangeDistance = self.lastAverageSpeed * self.changeDuration
        offsetDistance = self.endSpeed * offsetTime
        self.cacheDistance = offsetDistance + lastChangeDistance
      end
    else
      offsetDistance = self.endSpeed * offsetTime
      self.cacheDistance = offsetDistance
    end
    if self.isEditor or self.isDebug then
      str = str .. "totalDeltaTime = " .. totalDeltaTime .. ", last baseDistance = " .. self.baseDistance .. ", startSpeed = " .. self.endSpeed .. ", endSpeed = " .. toSpeed .. ", offsetTime = " .. offsetTime .. ", lastAverageSpeed = " .. self.lastAverageSpeed .. ", duration = " .. duration .. ", offsetDistance = " .. offsetDistance .. ", cacheDistance = " .. self.cacheDistance .. ", last cacheTimer = " .. self.cacheTimer
    end
    local lastAverageSpeed = (self.startSpeed + toSpeed) * 0.5
    self.lastAverageSpeed = lastAverageSpeed
    self.changeDuration = duration
    self.cacheTimer = totalDeltaTime
    self.baseTime = self.baseTime + self.cacheTime
    self.baseDistance = self.baseDistance + self.cacheDistance
    if self.isEditor or self.isDebug then
      str = str .. ", cacheTime = " .. self.cacheTime .. ", baseTime = " .. self.baseTime .. ", baseDistance = " .. self.baseDistance
    end
  end
  self.endSpeed = toSpeed
  if self.isEditor or self.isDebug then
    table.insert(self.logStr, str)
  end
  if self.unit then
    self.unit:SetMoveBase(self.baseTime, self.baseDistance, self.startSpeed, self.endSpeed, duration)
  end
end

function HandleSpeedHelper:GetLogStr()
  local result = table.concat(self.logStr, "\n")
  return result
end

return HandleSpeedHelper
