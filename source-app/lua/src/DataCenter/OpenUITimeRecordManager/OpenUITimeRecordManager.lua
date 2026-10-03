local OpenUITimeRecordManager = BaseClass("OpenUITimeRecordManager")
local OnceRecordMaxNum = 10
local RecordMaxWaitTime = 10
local MsgKeyStr = "OpenWindow2WithTime"

local function __init(self)
  self.nextSendTime = 0
  self.recordList = {}
  self.timer = nil
end

local function __delete(self)
  self.nextSendTime = nil
  self.recordList = nil
  self:StopTimer()
end

local function StopTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddRecord(self, ui_name, allTime, loadAssetTime, createFuncTime)
  table.insert(self.recordList, {
    ui_name,
    allTime,
    loadAssetTime,
    createFuncTime
  })
  if #self.recordList >= OnceRecordMaxNum then
    self:SendRecordData()
  else
    self:TryStartTimer()
  end
end

local function SendRecordData(self)
  local sendStr = ""
  local sendNum = math.min(#self.recordList, OnceRecordMaxNum)
  if sendNum <= 0 then
    return
  end
  sendStr = MsgKeyStr .. " "
  for i = 1, sendNum do
    local record = self.recordList[i]
    sendStr = sendStr .. string.format("%s;%.1f;%.1f;%.1f", record[1], record[2], record[3], record[4])
    if i < sendNum then
      sendStr = sendStr .. "|"
    end
  end
  self.recordList = {}
  self:StopTimer()
  self.nextSendTime = 0
  Logger.LogInfo(sendStr)
end

local function TryStartTimer(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.nextSendTime = curTime + RecordMaxWaitTime * 1000
  if self.timer ~= nil then
    return
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.TimeAction, self, false, false, false)
  self.timer:Start()
end

local function TimeAction(self)
  if self.nextSendTime == nil or self.nextSendTime <= 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.nextSendTime then
    self:SendRecordData()
  end
end

OpenUITimeRecordManager.__init = __init
OpenUITimeRecordManager.__delete = __delete
OpenUITimeRecordManager.StopTimer = StopTimer
OpenUITimeRecordManager.AddRecord = AddRecord
OpenUITimeRecordManager.SendRecordData = SendRecordData
OpenUITimeRecordManager.TryStartTimer = TryStartTimer
OpenUITimeRecordManager.TimeAction = TimeAction
return OpenUITimeRecordManager
