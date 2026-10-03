local LWWorldTrendTemplate = BaseClass("LWWorldTrendTemplate")
local LWWorldTrendEventTemplate = require("DataCenter.LWWorldTrendManager.LWWorldTrendEventTemplate")
local hour = 3600000

function LWWorldTrendTemplate:__init()
  self.id = 0
  self.name = 0
  self.eventList = 0
  self.stage_time = 0
  self.allDayInfos = {}
  self.dayList = {}
  self.dayInfoDic = {}
  self.dataDic = {}
  self.eventSortList = {}
end

function LWWorldTrendTemplate:__delete()
  self.id = nil
  self.name = nil
  self.eventList = nil
  self.stage_time = nil
end

function LWWorldTrendTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("stage_name")
  local eventStr = row:getValue("stage_event")
  self.eventList = {}
  if not string.IsNullOrEmpty(eventStr) then
    local idList = string.split(eventStr, ",")
    for i, id in pairs(idList) do
      local cityCfg = LocalController:instance():getLine(TableName.LW_WorldTrends_Event, id)
      local item = LWWorldTrendEventTemplate.New()
      item:InitData(cityCfg)
      table.insert(self.eventList, item)
    end
  end
  self.stage_time = row:getValue("stage_time")
end

function LWWorldTrendTemplate:GetEndTime()
  local time = 0
  if 0 < LuaEntry.Player.openServerTime then
    time = UITimeManager:GetInstance():GetDayTimeTransition(LuaEntry.Player.openServerTime)
  end
  return self.stage_time * hour + time
end

function LWWorldTrendTemplate:GetAllDataInfo()
  local serverId = LuaEntry.Player:GetSourceServerId()
  local t = self.allDayInfos
  if t and 0 < #t then
    for i = #t, 1, -1 do
      local v = t[i]
      local shouldKeep = false
      if not table.IsNullOrEmpty(v.event_server) then
        for key, value in pairs(v.event_server) do
          if serverId >= tonumber(key) and serverId <= tonumber(value) then
            shouldKeep = true
            break
          end
        end
      else
        shouldKeep = true
      end
      if not shouldKeep then
        table.remove(t, i)
      end
    end
  end
  return self.allDayInfos
end

function LWWorldTrendTemplate:GetAllDayTop()
  return self.dayList
end

function LWWorldTrendTemplate:GetDataById(id)
  return self.dataDic[id]
end

function LWWorldTrendTemplate:GetDayInfoDic()
  return self.dayInfoDic
end

function LWWorldTrendTemplate:GetIndexByDay(day)
  for i = 1, #self.allDayInfos do
    if self.allDayInfos.event_paral == day then
      return i
    end
  end
end

function LWWorldTrendTemplate:GetEndDayByCurDay(day)
  for i = 1, #self.dayList do
    if self.dayList[i] == day then
      return self.dayList[i + 1]
    end
  end
end

return LWWorldTrendTemplate
