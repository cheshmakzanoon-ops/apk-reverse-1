local AllianceLogManager = BaseClass("AllianceLogManager")
local AllianceLogInfo = require("DataCenter.AllianceData.AllianceLogInfo")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.logData = {}
  self.logDataArray = {}
  self.logTabRed = {}
  self.isWaitData = {}
  self.analyseData = {}
  self.lastSendTime = 0
  self.logTabGetFinsh = {}
  self.groupList = nil
  self.isClear = true
end

local function __delete(self)
  self.logData = nil
  self.logDataArray = nil
  self.logTabRed = nil
  self.isWaitData = nil
  self.analyseData = nil
  self.lastSendTime = nil
  self.groupList = nil
  self.logTabGetFinsh = nil
  self.isClear = nil
end

local function InitData(self)
  self.logData = {}
  self.isWaitData = {}
  self.analyseData = {}
  self.lastSendTime = 0
  self.logDataArray = {}
  for index, value in ipairs(AllianceLogTab) do
    self.logDataArray[index] = {}
    self.logTabRed[index] = false
    self.logTabGetFinsh[index] = false
  end
end

local function RequestTabInitLog(self, index)
  self.isClear = false
  SFSNetwork.SendMessage(MsgDefines.ViewAllianceLog, 0, false, index)
end

local function UpdateAllianceLogData(self, message, pageId)
  if self.isClear then
    return
  end
  if message ~= nil then
    if 0 < #message then
      for i = 1, #message do
        if self.logData[message[i].uuid] == nil then
          local tempData = AllianceLogInfo.New()
          tempData:ParseData(message[i])
          self.logData[message[i].uuid] = tempData
          table.insert(self.isWaitData, tempData)
          table.insert(self.logDataArray[pageId], tempData)
        end
      end
      if next(self.isWaitData) then
        self:AnalyseLogTime(self.isWaitData, false)
      end
    else
      self.logTabGetFinsh[pageId] = true
    end
  end
end

local function GetAllLog(self, page)
  if self.logDataArray[page] and next(self.logDataArray[page]) then
    return self.logDataArray[page]
  end
  return nil
end

local function GetAllianceLogById(self, page, index)
  if page and index and next(self.logDataArray) and self.logDataArray[page][index] then
    return self.logDataArray[page][index]
  end
  return nil
end

local function AnalyseLogTime(self, data, isPush)
  local emptyList = {}
  for i = 1, #data do
    emptyList[i] = {}
  end
  for i = 1, #data do
    if i ~= 1 and i == #data then
      break
    end
    if #data == 1 then
      self.isWaitData = {}
      if next(self.analyseData) then
        local time1 = os.date("*t", math.ceil(data[i].time * 0.001))
        local time2
        if isPush then
          time2 = self.analyseData[table.count(self.analyseData)]
        else
          for k = 1, #self.analyseData do
            if type(self.analyseData[k]) == "number" then
              time2 = self.analyseData[k]
              break
            end
          end
        end
        if data[i].time - time2 <= 1200000 then
          time2 = os.date("*t", math.ceil(time2 * 0.001))
          if time1.hour == time2.hour then
            if isPush then
              table.insert(self.analyseData, table.count(self.analyseData), data[i])
            else
              table.insert(self.analyseData, 1, data[i])
            end
            EventManager:GetInstance():Broadcast(EventId.AllianceLogUpdate)
            return
          end
        end
      end
      if isPush then
        table.insert(self.analyseData, table.count(self.analyseData) + 1, data[i])
        table.insert(self.analyseData, table.count(self.analyseData) + 1, data[i].time)
      else
        table.insert(self.analyseData, 1, data[i].time)
        table.insert(self.analyseData, 1, data[i])
      end
      EventManager:GetInstance():Broadcast(EventId.AllianceLogUpdate)
      return
    end
    local time1 = os.date("*t", math.ceil(data[i].time * 0.001))
    local time2 = os.date("*t", math.ceil(data[i + 1].time * 0.001))
    if data[i].time - data[i + 1].time <= 1200000 then
      if time1.hour == time2.hour then
        if next(emptyList[i]) then
          table.insert(emptyList[i], data[i + 1])
          emptyList[i + 1] = emptyList[i]
          emptyList[i] = {}
        else
          table.insert(emptyList[i + 1], data[i])
          table.insert(emptyList[i + 1], data[i + 1])
        end
      else
        if not next(emptyList[i]) then
          table.insert(emptyList[i], data[i])
        end
        table.insert(emptyList[i + 1], data[i + 1])
      end
    else
      if i == 1 then
        table.insert(emptyList[i], data[i])
      end
      table.insert(emptyList[i + 1], data[i + 1])
    end
  end
  for i = 1, #emptyList do
    if next(emptyList[i]) then
      table.insert(self.analyseData, 1, emptyList[i][table.length(emptyList[i])].time)
      for k = 1, #emptyList[i] do
        table.insert(self.analyseData, 1, emptyList[i][k])
      end
    end
  end
  self.isWaitData = {}
  EventManager:GetInstance():Broadcast(EventId.AllianceLogUpdate)
end

local function GetAnalyseData(self)
  local count = #self.analyseData
  return self.analyseData, count
end

local function GetLastLogTime(self)
  return self.lastSendTime
end

local function SetLastLogTime(self, time)
  self.lastSendTime = time
end

local function ClearAllianceLog(self)
  self.logData = {}
  for index, value in ipairs(self.logDataArray) do
    self.logDataArray[index] = {}
    self.logTabRed[index] = false
    self.logTabGetFinsh[index] = false
  end
  self.analyseData = {}
  self.isClear = true
end

local function InitTabGroupList(self)
  self.groupList = {}
  for index, value in ipairs(AllianceLogTab) do
    local temp = CommonTabGoupItemTemplate.New()
    temp.title = Localization:GetString(value.title)
    temp.eventId = EventId.AllianceRecordTabGroupRefreshRed
    table.insert(self.groupList, temp)
  end
end

local function GetTabGroupList(self)
  if self.groupList == nil then
    self:InitTabGroupList()
  end
  return self.groupList
end

local function SetTabRed(self, pageId, isRed)
  self.logTabRed[pageId] = isRed
  EventManager:GetInstance():Broadcast(EventId.AllianceRecordTabGroupRefreshRed, pageId)
end

local function GetTabRed(self, pageId)
  return self.logTabRed[pageId]
end

local function GetNeedGetMore(self, pageId)
  return not self.logTabGetFinsh[pageId]
end

AllianceLogManager.__init = __init
AllianceLogManager.__delete = __delete
AllianceLogManager.InitData = InitData
AllianceLogManager.UpdateAllianceLogData = UpdateAllianceLogData
AllianceLogManager.GetAllLog = GetAllLog
AllianceLogManager.AnalyseLogTime = AnalyseLogTime
AllianceLogManager.GetAllianceLogById = GetAllianceLogById
AllianceLogManager.ClearAllianceLog = ClearAllianceLog
AllianceLogManager.GetLastLogTime = GetLastLogTime
AllianceLogManager.SetLastLogTime = SetLastLogTime
AllianceLogManager.GetAnalyseData = GetAnalyseData
AllianceLogManager.InitTabGroupList = InitTabGroupList
AllianceLogManager.GetTabGroupList = GetTabGroupList
AllianceLogManager.SetTabRed = SetTabRed
AllianceLogManager.GetTabRed = GetTabRed
AllianceLogManager.GetNeedGetMore = GetNeedGetMore
AllianceLogManager.RequestTabInitLog = RequestTabInitLog
return AllianceLogManager
