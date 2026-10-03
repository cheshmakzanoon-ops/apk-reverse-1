local QueueInfo = BaseClass("QueueInfo")

local function __init(self)
  self.uuid = 0
  self.startTime = 0
  self.endTime = 0
  self.state = NewQueueState.Free
  self.type = NewQueueType.Default
  self.itemId = ""
  self.newItemId = ""
  self.isHelped = 0
  self.funcUuid = 0
  self.qid = 0
  self.para = QueueProductState.DEFAULT
  self.lastHelpTime = 0
  self.helpNum = 0
  self.para2 = 0
end

local function __delete(self)
  self.uuid = nil
  self.startTime = nil
  self.endTime = nil
  self.state = nil
  self.type = nil
  self.itemId = nil
  self.newItemId = nil
  self.isHelped = nil
  self.funcUuid = nil
  self.para = nil
  self.qid = nil
  self.para2 = nil
  self.lastHelpTime = nil
  self.helpNum = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.sT ~= nil then
    self.startTime = message.sT
  else
    self.startTime = 0
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.qid ~= nil then
    self.qid = message.qid
  end
  if message.uT ~= nil then
    self.endTime = message.uT
  else
    self.endTime = 0
  end
  if message.updateTime ~= nil then
    self.endTime = message.updateTime
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.isHelped ~= nil then
    self.isHelped = message.isHelped
  else
    self.isHelped = 0
  end
  if message.itemObj ~= nil then
    local temp = message.itemObj
    if temp ~= nil then
      if temp.newItemId ~= nil then
        self.newItemId = temp.newItemId
      end
      if temp.itemId ~= nil then
        self.itemId = temp.itemId
      end
    end
  end
  if message.funcUuid ~= nil then
    self.funcUuid = message.funcUuid
  else
    self.funcUuid = 0
  end
  if message.para ~= nil then
    self.para = message.para
  else
    self.para = QueueProductState.DEFAULT
  end
  if message.para2 then
    self.para2 = message.para2
  end
  if message.lastHelpTime then
    self.lastHelpTime = message.lastHelpTime
  end
  if message.helpNum then
    self.helpNum = message.helpNum
  end
  self:SetQueueState(false)
end

local function SetQueueState(self, reset)
  if reset then
    self.state = NewQueueState.Free
  elseif self.startTime ~= 0 and self.startTime == self.endTime then
    if self.state == NewQueueState.Work and self.type == NewQueueType.DragonHospital then
      SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
        uuid = self.uuid
      })
    end
    self.state = NewQueueState.Finish
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.endTime then
      self.state = NewQueueState.Work
    elseif curTime >= self.endTime and self.endTime ~= 0 then
      if self.state == NewQueueState.Work and self.type == NewQueueType.DragonHospital then
        SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
          uuid = self.uuid
        })
      end
      self.state = NewQueueState.Finish
    else
      self.state = NewQueueState.Free
    end
  end
end

local function GetQueueState(self)
  self:SetQueueState(false)
  return self.state
end

local function ResetQueue(self, paraState)
  self.startTime = 0
  self.endTime = 0
  self.newItemId = ""
  self.isHelped = 0
  self.para2 = 0
  self:SetQueueState(true)
  if paraState ~= nil then
    self.para = paraState
  else
    self.para = QueueProductState.DEFAULT
  end
  if self.para == QueueProductState.DEFAULT then
    self.itemId = ""
  end
end

local function SetIrrigateState(self)
  return self.para2
end

local function CheckIfIrrigated(self)
  return self.para2 == 1
end

local function GetParaState(self)
  return self.para
end

local function IsEnd(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.endTime > 0 and self.endTime ~= LongMaxValue and curTime < self.endTime then
    return false
  end
  return true
end

local function SetQueueFinishForFarm(self)
  self.endTime = self.startTime
end

QueueInfo.__init = __init
QueueInfo.__delete = __delete
QueueInfo.ParseData = ParseData
QueueInfo.SetQueueState = SetQueueState
QueueInfo.GetQueueState = GetQueueState
QueueInfo.ResetQueue = ResetQueue
QueueInfo.GetParaState = GetParaState
QueueInfo.IsEnd = IsEnd
QueueInfo.SetQueueFinishForFarm = SetQueueFinishForFarm
QueueInfo.SetIrrigateState = SetIrrigateState
QueueInfo.CheckIfIrrigated = CheckIfIrrigated
return QueueInfo
