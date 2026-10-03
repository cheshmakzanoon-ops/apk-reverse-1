local ActDispatchTaskFakeMarchData = BaseClass("ActDispatchTaskFakeMarchData")
local retry_gap_time = 10000
local FakeMarchState = {
  FAKE_MARCH_STATE_NULL = 0,
  FAKE_MARCH_TO_GARBAGE = 1,
  FAKE_MARCH_COLLECT_GARBAGE = 2,
  FAKE_MARCH_GO_HOME = 3,
  FAKE_MARCH_ARRIVE_HOME = 4
}

local function __init(self)
  self.startIndex = 0
  self.endIndex = 0
  self.startTime = 0
  self.GarbageStartTime = 0
  self.backHomeTime = 0
  self.arriveHomeTime = 0
  self.curState = FakeMarchState.FAKE_MARCH_STATE_NULL
end

local function __delete(self)
  self.startIndex = nil
  self.endIndex = nil
  self.startTime = nil
  self.GarbageStartTime = nil
  self.backHomeTime = nil
  self.arriveHomeTime = nil
end

local function SetStartAndEndIndex(self, pointIndex, startIndex, endIndex, backHome)
  self.pointIndex = toInt(pointIndex)
  self.startIndex = toInt(startIndex)
  self.endIndex = toInt(endIndex)
  self.backHome = backHome
  if self.pointIndex <= 0 or self.startIndex <= 0 or self.endIndex <= 0 then
    Logger.LogInfo(string.format("ERR -> forceType : %s , %s , %s", self.pointIndex, self.startIndex, self.endIndex))
  end
end

local function UpdateState(self, curTime)
  if self.curState == FakeMarchState.FAKE_MARCH_STATE_NULL then
    self:StartMarch()
  elseif self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE and curTime >= self.GarbageStartTime then
    self:CheckAndStartCollectGarbage(curTime)
  elseif self.curState == FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE and curTime >= self.backHomeTime then
    self:CheckAndGoBack(curTime)
  elseif self.curState == FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.arriveHomeTime then
    self:CheckBackHome(curTime)
  end
  self:SendPickEndMessage()
end

local function StartMarch(self)
  if self.curState == FakeMarchState.FAKE_MARCH_STATE_NULL then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local marchTime = self:CalculateMarchTime()
    if self.backHome then
      self.curState = FakeMarchState.FAKE_MARCH_GO_HOME
      self.startTime = math.ceil(curTime)
      self.backHomeTime = self.startTime
      self.arriveHomeTime = math.ceil(curTime + marchTime)
      self.GarbageStartTime = self.arriveHomeTime
    else
      self.curState = FakeMarchState.FAKE_MARCH_TO_GARBAGE
      self.startTime = math.ceil(curTime)
      self.GarbageStartTime = math.ceil(curTime + marchTime)
      self.backHomeTime = math.ceil(self.GarbageStartTime + self:CalculateCollectGarbageTime())
      self.arriveHomeTime = math.ceil(self.backHomeTime + marchTime)
    end
    if CS.SceneManager:IsInWorld() then
      if self.backHome then
        CS.SceneManager.World:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.BACK_HOME)
      else
        CS.SceneManager.World:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.DISPATCH_TASK)
      end
    end
  end
end

local function CheckAndStartCollectGarbage(self, curTime)
  if self.curState ~= FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE and curTime >= self.GarbageStartTime then
    self.curState = FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:UpdateFakeSampleMarchDataWhenStartPick(self.endIndex, self.backHomeTime)
    end
  end
end

local function CheckAndGoBack(self, curTime)
  if self.curState ~= FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.backHomeTime then
    self.curState = FakeMarchState.FAKE_MARCH_GO_HOME
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:UpdateFakeSampleMarchDataWhenBack(self.endIndex, self.backHomeTime, self.arriveHomeTime + 1000)
    end
  end
end

local function SendPickEndMessage(self)
end

local function CheckBackHome(self, curTime)
  if self.curState == FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.arriveHomeTime then
    self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
    self:Remove()
  end
end

local function CalculateMarchTime(self)
  local startPt = SceneUtils.IndexToTilePos(self.startIndex, ForceChangeScene.World)
  local endPt = SceneUtils.IndexToTilePos(self.endIndex, ForceChangeScene.World)
  local dis = Vector2.Distance(startPt, endPt)
  local speed = LuaEntry.DataConfig:TryGetNum("armyspeed", "k2")
  local time = math.ceil(dis * 1000 / speed)
  return time
end

local function CalculateCollectGarbageTime(self)
  local info = CS.SceneManager.World:GetPointInfo(self.pointIndex)
  if info == nil or string.IsNullOrEmpty(info.pointIndex) then
    return 1
  end
  local cfg = LocalController:instance():getLine(TableName.LwDispatchTask, info.cfgId)
  if cfg == nil then
    return 1
  end
  if string.IsNullOrEmpty(cfg.times) then
    return 1
  end
  return toInt(cfg.times) * 1000
end

local function Remove(self)
  if CS.SceneManager:IsInWorld() then
    CS.SceneManager.World:RemoveFakeSampleMarchData(self.endIndex)
    EventManager:GetInstance():Broadcast(EventId.MarchItemUpdateSelf)
  end
end

local function NeedRemove(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE and curTime >= self.GarbageStartTime then
    return true
  end
  if self.curState == FakeMarchState.FAKE_MARCH_ARRIVE_HOME and curTime >= self.arriveHomeTime then
    return true
  end
  return false
end

local function IsEventDoing(self)
  return self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE or self.curState == FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE
end

local function DoWhenBackToWorld(self)
  if CS.SceneManager.World:ExistMarch(self.endIndex) then
    return
  end
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.endIndex)
  if pointInfo == nil then
    return
  end
  if self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE or self.curState == FakeMarchState.FAKE_MARCH_GO_HOME then
    CS.SceneManager.World:RemoveFakeSampleMarchData(self.endIndex)
    CS.SceneManager.World:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.DISPATCH_TASK)
  else
    self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
    self:UpdateState(UITimeManager:GetInstance():GetServerTime())
  end
end

ActDispatchTaskFakeMarchData.__init = __init
ActDispatchTaskFakeMarchData.__delete = __delete
ActDispatchTaskFakeMarchData.SetStartAndEndIndex = SetStartAndEndIndex
ActDispatchTaskFakeMarchData.StartMarch = StartMarch
ActDispatchTaskFakeMarchData.CheckAndStartCollectGarbage = CheckAndStartCollectGarbage
ActDispatchTaskFakeMarchData.CheckAndGoBack = CheckAndGoBack
ActDispatchTaskFakeMarchData.CalculateMarchTime = CalculateMarchTime
ActDispatchTaskFakeMarchData.CalculateCollectGarbageTime = CalculateCollectGarbageTime
ActDispatchTaskFakeMarchData.UpdateState = UpdateState
ActDispatchTaskFakeMarchData.Remove = Remove
ActDispatchTaskFakeMarchData.CheckBackHome = CheckBackHome
ActDispatchTaskFakeMarchData.SendPickEndMessage = SendPickEndMessage
ActDispatchTaskFakeMarchData.NeedRemove = NeedRemove
ActDispatchTaskFakeMarchData.IsEventDoing = IsEventDoing
ActDispatchTaskFakeMarchData.DoWhenBackToWorld = DoWhenBackToWorld
return ActDispatchTaskFakeMarchData
