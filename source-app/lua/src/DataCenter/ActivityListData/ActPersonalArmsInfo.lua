local ActPersonalArmsInfo = BaseClass("ActPersonalArmsInfo")

local function __init(self)
  self.activityId = ""
  self.eventType = ActivityEventType.NULL
  self.vsAllianceInfo = nil
  self.winReward = nil
  self.eventInfo = nil
  self.ranking = nil
  self.list = {}
  self.calendar = {}
end

local function __delete(self)
  self.activityId = ""
  self.eventType = ActivityEventType.NULL
  self.vsAllianceInfo = nil
  self.winReward = nil
  self.eventInfo = nil
  self.ranking = nil
  self.list = nil
  self.calendar = nil
end

local function SetActivityId(self, id)
  self.list[id] = {}
  self.activityId = id
  self.eventType = ActivityEventType.PERSONAL
end

local function ParseEventData(self, message)
  if message == nil then
    return
  end
  if message.type ~= nil then
    local type = message.type
    if type == self.eventType then
      for i, v in pairs(self.list) do
        if i == message.activityId then
          if message.ranking ~= nil then
            self.list[i].ranking = message.ranking
          end
          if message.eventList ~= nil then
            table.walk(message.eventList, function(k, v)
              local oneData = ActivityEventInfo.New()
              oneData:ParseData(v)
              if oneData.type == self.eventType then
                self.list[i].eventInfo = oneData
              end
            end)
          end
          if message.chooseArr ~= nil then
            self.list[i].chooseArr = {}
            for k = 1, #message.chooseArr do
              local param = {}
              param.eventId = message.chooseArr[k].eventId
              param.effectId = message.chooseArr[k].effectId
              param.name = message.chooseArr[k].name
              param.chooseNum = message.chooseArr[k].chooseNum
              table.insert(self.list[i].chooseArr, param)
            end
          end
          break
        end
      end
    end
  end
end

local function GetRanking(self, activityId)
  if self.list[activityId] then
    return self.list[activityId].ranking
  end
  return 0
end

local function GetEventInfo(self, activityId)
  if self.list[activityId] then
    return self.list[activityId].eventInfo
  end
  return nil
end

local function GetChooseArr(self, activityId)
  if self.list[activityId] then
    return self.list[activityId].chooseArr
  end
  return nil
end

local function GetScoreMeth(self, activityId)
  if self.list[activityId] then
    return self.list[activityId].eventInfo.getScoreMeth
  end
  return nil
end

local function ClearEventInfo(self, activityId)
  self.list[activityId] = nil
end

local function SetCalendar(self, message)
  if message.dayArr then
    self.calendar.dayArr = {}
    for i = 1, #message.dayArr do
      local param = {}
      param.eventArr = message.dayArr[i].eventArr
      param.day = message.dayArr[i].day
      table.insert(self.calendar.dayArr, param)
    end
    table.sort(self.calendar.dayArr, function(a, b)
      if a.day < b.day then
        return true
      end
      return false
    end)
    self.calendar.actTime = message.actTime
  end
end

local function GetCalendar(self)
  if next(self.calendar) then
    return self.calendar
  end
  return nil
end

ActPersonalArmsInfo.__init = __init
ActPersonalArmsInfo.__delete = __delete
ActPersonalArmsInfo.SetActivityId = SetActivityId
ActPersonalArmsInfo.ParseEventData = ParseEventData
ActPersonalArmsInfo.GetRanking = GetRanking
ActPersonalArmsInfo.GetEventInfo = GetEventInfo
ActPersonalArmsInfo.GetChooseArr = GetChooseArr
ActPersonalArmsInfo.GetScoreMeth = GetScoreMeth
ActPersonalArmsInfo.ClearEventInfo = ClearEventInfo
ActPersonalArmsInfo.SetCalendar = SetCalendar
ActPersonalArmsInfo.GetCalendar = GetCalendar
return ActPersonalArmsInfo
