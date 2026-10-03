local FakeParkourRescueMarchData = BaseClass("FakeParkourRescueMarchData")
local Resource = CS.GameEntry.Resource
local FakeParkourRescueObject = require("DataCenter.RadarCenterDataManager.FakeParkourRescueObject")
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
  self:RemoveModel()
  self.startIndex = nil
  self.endIndex = nil
  self.startTime = nil
  self.GarbageStartTime = nil
  self.backHomeTime = nil
  self.arriveHomeTime = nil
end

local function SetStartAndEndIndex(self, pointIndex, startIndex, endIndex, modelPath)
  self.pointIndex = pointIndex
  self.startIndex = startIndex
  self.endIndex = endIndex
  self:CreateModel(pointIndex, modelPath)
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
    self.curState = FakeMarchState.FAKE_MARCH_TO_GARBAGE
    self.startTime = math.ceil(curTime)
    local marchTime = self:CalculateMarchTime()
    self.GarbageStartTime = math.ceil(curTime + marchTime)
    self.backHomeTime = math.ceil(self.GarbageStartTime + self:CalculateCollectGarbageTime())
    self.arriveHomeTime = math.ceil(self.backHomeTime + marchTime)
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.RESCUE_FAKE_MARCH)
    end
  end
end

local function CheckAndStartCollectGarbage(self, curTime)
  if self.curState ~= FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE and curTime >= self.GarbageStartTime then
    self.curState = FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:UpdateFakeSampleMarchDataWhenStartPick(self.endIndex, self.backHomeTime)
      if self.rescueObject then
        self.rescueObject:DoWhenCollectStart()
      end
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
  if self.curState == FakeMarchState.FAKE_MARCH_GO_HOME or self.curState == FakeMarchState.FAKE_MARCH_ARRIVE_HOME then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.callTime == nil or now - self.callTime > retry_gap_time then
      self.callTime = now
      self:RemoveModel()
    end
  end
end

local function CheckBackHome(self, curTime)
  if self.curState == FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.arriveHomeTime then
    self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
    self:Remove()
    DataCenter.FakeParkourRescueMarchManager:RemoveMarchIndex(self.endIndex)
  end
end

local function CalculateMarchTime(self)
  local startPt = SceneUtils.IndexToTilePos(self.startIndex)
  local endPt = SceneUtils.IndexToTilePos(self.endIndex)
  local dis = Vector2.Distance(startPt, endPt)
  local speed = LuaEntry.DataConfig:TryGetNum("armyspeed", "k9", 6)
  local time = dis * 1000 / speed
  return time
end

local function CalculateCollectGarbageTime(self)
  return 4000
end

local function Remove(self)
  if CS.SceneManager:IsInWorld() then
    CS.SceneManager.World:RemoveFakeSampleMarchData(self.endIndex)
  end
  self:RemoveModel()
end

local function NeedRemove(self)
  if self.curState == FakeMarchState.FAKE_MARCH_ARRIVE_HOME or DataCenter.FakeParkourRescueMarchManager:NeedRemove(self.pointIndex) then
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
  if self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE then
    CS.SceneManager.World:RemoveFakeSampleMarchData(self.endIndex)
    CS.SceneManager.World:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.RESCUE_FAKE_MARCH)
  else
    self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
    self:UpdateState(UITimeManager:GetInstance():GetServerTime())
  end
end

local function RemoveModel(self)
  if self.rescueObject then
    self.rescueObject:Delete()
    self.rescueObject = nil
  end
end

local function CreateModel(self, pointIndex, modelPath)
  self:RemoveModel()
  self.rescueObject = FakeParkourRescueObject.New("FakeParkourRescueObject" .. pointIndex, CS.SceneManager.World.DynamicObjNode, modelPath, function(go)
    if IsNotNull(go) then
      go.transform.position = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World)
    end
  end)
end

FakeParkourRescueMarchData.__init = __init
FakeParkourRescueMarchData.__delete = __delete
FakeParkourRescueMarchData.SetStartAndEndIndex = SetStartAndEndIndex
FakeParkourRescueMarchData.StartMarch = StartMarch
FakeParkourRescueMarchData.CheckAndStartCollectGarbage = CheckAndStartCollectGarbage
FakeParkourRescueMarchData.CheckAndGoBack = CheckAndGoBack
FakeParkourRescueMarchData.CalculateMarchTime = CalculateMarchTime
FakeParkourRescueMarchData.CalculateCollectGarbageTime = CalculateCollectGarbageTime
FakeParkourRescueMarchData.UpdateState = UpdateState
FakeParkourRescueMarchData.Remove = Remove
FakeParkourRescueMarchData.CheckBackHome = CheckBackHome
FakeParkourRescueMarchData.SendPickEndMessage = SendPickEndMessage
FakeParkourRescueMarchData.NeedRemove = NeedRemove
FakeParkourRescueMarchData.IsEventDoing = IsEventDoing
FakeParkourRescueMarchData.DoWhenBackToWorld = DoWhenBackToWorld
FakeParkourRescueMarchData.RemoveModel = RemoveModel
FakeParkourRescueMarchData.CreateModel = CreateModel
return FakeParkourRescueMarchData
