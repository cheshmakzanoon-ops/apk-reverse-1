local SeasonCampDestroyWarTimeConfigData = BaseClass("SeasonCampDestroyWarTimeConfigData")

function SeasonCampDestroyWarTimeConfigData:__init()
end

function SeasonCampDestroyWarTimeConfigData:__delete()
end

function SeasonCampDestroyWarTimeConfigData:SetData(timeStr, index)
  local timePair = string.split(timeStr, ";")
  if timePair ~= nil and #timePair == 2 then
    self.ServerStartTimeStr = timePair[1]
    self.ServerEndTimeStr = timePair[2]
    self.StartTime = self:TimeStrToSeconds(timePair[1])
    self.EndTime = self:TimeStrToSeconds(timePair[2])
    self.StartTimeMS = self.StartTime * 1000
    self.EndTimeMS = self.EndTime * 1000
    self.LocalStartTimeStr = self:SecondsToTimeStr(UITimeManager:GetInstance():GetServerTimeToLocal(self.StartTime))
    self.LocalEndTimeStr = self:SecondsToTimeStr(UITimeManager:GetInstance():GetServerTimeToLocal(self.EndTime))
  end
  self.Index = index
end

function SeasonCampDestroyWarTimeConfigData:GetServerTimeRangeStr()
  return string.format("%s - %s", self.ServerStartTimeStr, self.ServerEndTimeStr)
end

function SeasonCampDestroyWarTimeConfigData:GetLocalTimeRangeStr()
  return string.format("%s - %s", self.LocalStartTimeStr, self.LocalEndTimeStr)
end

function SeasonCampDestroyWarTimeConfigData:IsNowInRange(time)
  if checknumber(time) == 0 then
    time = UITimeManager:GetInstance():GetServerTime()
  end
  local past = time - UITimeManager:GetInstance():GetTodayZero()
  return past >= self.StartTimeMS and past < self.EndTimeMS
end

function SeasonCampDestroyWarTimeConfigData:GetImgClock()
  local index = Mathf.Clamp(checknumber(self.Index), 0, 2)
  if index == 0 then
    return "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_icon_shijian1.png"
  elseif index == 1 then
    return "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_icon_shijian2.png"
  elseif index == 2 then
    return "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_icon_shijian3.png"
  end
  return ""
end

function SeasonCampDestroyWarTimeConfigData:Description()
  return string.format("[Index:%s] Server:%s-%s Local:%s-%s", self.Index, self.ServerStartTimeStr, self.ServerEndTimeStr, self.LocalStartTimeStr, self.LocalEndTimeStr)
end

function SeasonCampDestroyWarTimeConfigData:TimeStrToSeconds(timeStr)
  local time = string.split(timeStr, ":")
  if time and #time == 3 then
    local h = checknumber(time[1])
    local m = checknumber(time[2])
    local s = checknumber(time[3])
    return h * 3600 + m * 60 + s
  end
  return 0
end

function SeasonCampDestroyWarTimeConfigData:SecondsToTimeStr(seconds)
  seconds = checknumber(seconds) % OneDayTime
  local h = math.floor(seconds / 3600)
  local m = math.floor(seconds / 60) % 60
  local s = math.floor(seconds) % 60
  return string.format("%02d:%02d:%02d", h, m, s)
end

return SeasonCampDestroyWarTimeConfigData
