local LWWorldTrendDataManager = BaseClass("LWWorldTrendDataManager")
local LWWorldTrendTemplateManager = require("DataCenter.LWWorldTrendManager.LWWorldTrendTemplateManager")

function LWWorldTrendDataManager:__init()
  self.curEventsId = nil
  self.curStageData = nil
  self.curEvent = nil
  self.templateManager = nil
  self.activityInfoMap = {}
  self.openServerZeroTime = 0
  self.curSeasonId = -1
  self.curSeasonStartTime = 0
end

function LWWorldTrendDataManager:__delete()
  self.curEventsId = nil
  self.curStageData = nil
  self.curEvent = nil
  self.templateManager = nil
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  self.activityInfoMap = nil
  self.openServerZeroTime = nil
  self.curSeasonId = nil
  self.curSeasonStartTime = nil
end

function LWWorldTrendDataManager:Startup()
end

function LWWorldTrendDataManager:InitData()
  self.templateManager = LWWorldTrendTemplateManager:New()
  self.allEvnetInfos = self.templateManager:InitAllTemplate()
  SFSNetwork.SendMessage(MsgDefines.WorldTrendActivitySync)
  self:UpdateCurData()
end

function LWWorldTrendDataManager:ParseActivityData(message)
  if message == nil then
    return
  end
  self.openServerZeroTime = tonumber(message.openTimeZero)
  self.curSeasonId = tonumber(message.curSeason) or 0
  self.curSeasonStartTime = tonumber(message.seasonTimeZero) or 0
  if message.data then
    for i, activityInfoJson in ipairs(message.data) do
      if activityInfoJson then
        local info = {}
        info.id = tonumber(activityInfoJson.id)
        info.startTime = activityInfoJson.startTime
        info.endTime = activityInfoJson.endTime
        self.activityInfoMap[info.id] = info
      end
    end
  end
  if not self.curStageData then
    return
  end
  for i = 1, table.count(self.curStageData.eventList) do
    local eventTemplate = self.curStageData.eventList[i]
    if eventTemplate.event_type == 1 then
      local activityInfo = self.activityInfoMap[eventTemplate.id]
      if activityInfo then
        eventTemplate.activity_start_time = activityInfo.startTime
        local deltaTime = eventTemplate.activity_start_time - self.openServerZeroTime
        eventTemplate.startDay = math.floor(deltaTime / 86400000) + 1
        if eventTemplate.event_time == 0 then
          eventTemplate.activity_end_time = activityInfo.endTime
        end
      else
        Logger.LogError("\230\156\141\229\138\161\229\153\168\230\156\170\228\184\139\229\143\145\232\175\165\230\180\187\229\138\168Id:" .. eventTemplate.id)
      end
    end
    local key = eventTemplate.startDay
    if key then
      if self.curStageData.dayInfoDic[key] then
        table.insert(self.curStageData.dayInfoDic[key], eventTemplate)
      else
        self.curStageData.dayInfoDic[key] = {}
        table.insert(self.curStageData.dayInfoDic[key], eventTemplate)
        table.insert(self.curStageData.dayList, key)
      end
      self.curStageData.dataDic[eventTemplate.id] = eventTemplate
    end
  end
  table.sort(self.curStageData.eventList, function(a, b)
    if a.startDay < b.startDay then
      return true
    elseif a.startDay == b.startDay and a.priority < b.priority then
      return true
    end
  end)
  table.sort(self.curStageData.dayList, function(a, b)
    if a < b then
      return true
    end
  end)
  for i, dayDataList in pairs(self.curStageData.dayInfoDic) do
    for i, v in pairs(dayDataList) do
      table.insert(self.curStageData.allDayInfos, v)
    end
  end
  table.sort(self.curStageData.allDayInfos, function(a, b)
    if a.event_type == 4 and b.event_type == 4 then
      return a.priority < b.priority
    elseif a.event_type == 4 then
      return false
    elseif b.event_type == 4 then
      return true
    end
    if a.startDay < b.startDay then
      return true
    elseif a.startDay == b.startDay and a.priority < b.priority then
      return true
    end
  end)
  self:UpdateCurEvent()
  EventManager:GetInstance():Broadcast(EventId.WorldTrendActivitySync)
end

function LWWorldTrendDataManager:GetCurSeasonId()
  return self.curSeasonId
end

function LWWorldTrendDataManager:GetCurSeasonStartTime()
  return self.curSeasonStartTime
end

function LWWorldTrendDataManager:GetOpenServerZeroTime()
  return self.openServerZeroTime
end

function LWWorldTrendDataManager:UpdateCurData()
  self.curEventsId = self:GetCurEventTempIndex()
  if self.curEventsId then
    self.curStageData = self.allEvnetInfos[self.curEventsId]
  else
    self.curStageData = self.allEvnetInfos[#self.allEvnetInfos]
  end
end

function LWWorldTrendDataManager:UpdateCurEvent(isUpdateCurData)
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  if not self.curStageData then
    return
  end
  self.curEvent = self:GetCurEvent()
  if self.curEvent then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.curEvent:GetEndTime()
    if endTime ~= -1 then
      local time = endTime - curTime
      if 0 < time then
        self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
          self:UpdateCurEvent()
        end, time / 1000 + 1)
      end
      EventManager:GetInstance():Broadcast(EventId.WorldTrendEventDataUpdate, self.curEvent.id)
    end
  elseif not isUpdateCurData then
    self:UpdateCurData()
    self:UpdateCurEvent(true)
  end
end

function LWWorldTrendDataManager:GetCurEvent()
  local tempData
  if self.curStageData then
    if self:GetIsEndEvent() then
      return self.curStageData.eventList[#self.curStageData.eventList]
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local startTime, endTime, time, lastSeason
    for i, data in pairs(self.curStageData.eventList) do
      if data.event_type == 4 then
        local curSeasonId = self:GetCurSeasonId()
        if curSeasonId < data.seasonId then
          goto lbl_66
        end
      end
      startTime = data:GetStartTime()
      endTime = data:GetEndTime()
      time = curTime - startTime
      if 0 < time and (curTime <= endTime or endTime == -1) then
        if lastSeason then
          if data.seasonId == lastSeason then
            tempData = data
            lastSeason = data.seasonId
          elseif lastSeason < data.seasonId then
            tempData = data
            lastSeason = data.seasonId
          end
        elseif lastSeason == nil then
          tempData = data
          lastSeason = data.seasonId
        end
      end
      ::lbl_66::
    end
  end
  return tempData
end

function LWWorldTrendDataManager:GetCurEventData()
  return self.curEvent
end

function LWWorldTrendDataManager:GetCurEventDataKey()
  if self.curStageData and self.curEvent then
    return LuaEntry.Player.uid .. self.curStageData.name .. self.curEvent.id
  end
end

function LWWorldTrendDataManager:GetCurEventTempIndex()
  if self.allEvnetInfos == nil then
    return 1
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for i = 1, #self.allEvnetInfos do
    if curTime < self.allEvnetInfos[i]:GetEndTime() then
      return i
    end
  end
end

function LWWorldTrendDataManager:GetIsEndEvent()
  return self:GetCurEventTempIndex() == nil
end

function LWWorldTrendDataManager:GetcurEventName()
  if self.curStageData then
    return self.curStageData.name
  elseif self.allEvnetInfos and table.count(self.allEvnetInfos) > 0 then
    return self.allEvnetInfos[#self.allEvnetInfos].name
  else
    return ""
  end
end

function LWWorldTrendDataManager:GetAllDataInfo()
  if self.curStageData then
    return self.curStageData:GetAllDataInfo()
  end
end

function LWWorldTrendDataManager:GetAllDayTop()
  if self.curStageData then
    return self.curStageData:GetAllDayTop()
  end
end

function LWWorldTrendDataManager:GetDataById(id)
  if self.curStageData then
    return self.curStageData:GetDataById(id)
  end
end

function LWWorldTrendDataManager:GetIndexByDay(day)
  if self.curStageData then
    return self.curStageData:GetIndexByDay(day)
  end
end

function LWWorldTrendDataManager:GetEndDayByCurDay(day)
  if self.curStageData then
    return self.curStageData:GetEndDayByCurDay(day)
  end
end

function LWWorldTrendDataManager:GetCurEventsEndTime()
  if self.curStageData then
    return self.curStageData:GetEndTime()
  end
end

function LWWorldTrendDataManager:GetDayInfoDic()
  if self.curStageData then
    return self.curStageData:GetDayInfoDic()
  end
end

return LWWorldTrendDataManager
