local AllianceCityLogManager = BaseClass("AllianceCityLogManager")
local AllianceLogInfo = require("DataCenter.AllianceData.AllianceLogInfo")

local function __init(self)
  self.logData = {}
  self.logDataArray = {}
  self.isWaitData = {}
  self.analyseData = {}
  self.lastSendTime = 0
end

local function __delete(self)
  self.logData = nil
  self.logDataArray = nil
  self.isWaitData = nil
  self.analyseData = nil
  self.lastSendTime = nil
end

local function InitData(self)
end

local function UpdateAllianceLogData(self, message)
  if message ~= nil then
    for i = 1, #message do
      if self.logData[message[i].uuid] == nil then
        local tempData = AllianceLogInfo.New()
        tempData:ParseData(message[i])
        self.logData[message[i].uuid] = tempData
        table.insert(self.logDataArray, tempData)
        table.insert(self.isWaitData, tempData)
      end
    end
    if next(self.isWaitData) then
      self:AnalyseLogTime(self.isWaitData, false)
    end
  end
end

local function PushAllianceLogMemberHandle(self, message)
  if self.logData[message.uuid] == nil then
    local tempData = AllianceLogInfo.New()
    tempData:ParseData(message)
    self.logData[message.uuid] = tempData
    table.insert(self.logDataArray, 1, tempData)
    table.insert(self.isWaitData, tempData)
    if next(self.isWaitData) then
      self:AnalyseLogTime(self.isWaitData, true)
    end
  end
end

local function GetAllLog(self)
  if next(self.logDataArray) then
    return self.logDataArray
  end
  return nil
end

local function GetAllianceLogById(self, index)
  if next(self.logDataArray) and self.logDataArray[index] then
    return self.logDataArray[index]
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
            EventManager:GetInstance():Broadcast(EventId.AllianceCityLogUpdate)
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
      EventManager:GetInstance():Broadcast(EventId.AllianceCityLogUpdate)
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
  EventManager:GetInstance():Broadcast(EventId.AllianceCityLogUpdate)
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
  self.logDataArray = {}
  self.analyseData = {}
end

AllianceCityLogManager.__init = __init
AllianceCityLogManager.__delete = __delete
AllianceCityLogManager.InitData = InitData
AllianceCityLogManager.UpdateAllianceLogData = UpdateAllianceLogData
AllianceCityLogManager.PushAllianceLogMemberHandle = PushAllianceLogMemberHandle
AllianceCityLogManager.GetAllLog = GetAllLog
AllianceCityLogManager.AnalyseLogTime = AnalyseLogTime
AllianceCityLogManager.GetAllianceLogById = GetAllianceLogById
AllianceCityLogManager.ClearAllianceLog = ClearAllianceLog
AllianceCityLogManager.GetLastLogTime = GetLastLogTime
AllianceCityLogManager.SetLastLogTime = SetLastLogTime
AllianceCityLogManager.GetAnalyseData = GetAnalyseData
return AllianceCityLogManager
