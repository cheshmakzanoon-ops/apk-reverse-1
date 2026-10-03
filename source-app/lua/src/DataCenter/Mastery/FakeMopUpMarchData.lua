local FakeMopUpMarchData = BaseClass("FakeMopUpMarchData")
local FakeMarchState = {
  FAKE_MARCH_STATE_NULL = 0,
  FAKE_MARCH_TO_GARBAGE = 1,
  FAKE_MARCH_COLLECT_GARBAGE = 2,
  FAKE_MARCH_GO_HOME = 3,
  FAKE_MARCH_ARRIVE_HOME = 4
}

function FakeMopUpMarchData:__init()
  self.startIndex = 0
  self.endIndex = 0
  self.startTime = 0
  self.GarbageStartTime = 0
  self.backHomeTime = 0
  self.arriveHomeTime = 0
  self.curState = FakeMarchState.FAKE_MARCH_STATE_NULL
end

function FakeMopUpMarchData:__delete()
  self.startIndex = nil
  self.endIndex = nil
  self.startTime = nil
  self.GarbageStartTime = nil
  self.backHomeTime = nil
  self.arriveHomeTime = nil
end

function FakeMopUpMarchData:SetStartAndEndIndex(pointIndex, startIndex, endIndex)
  self.pointIndex = pointIndex
  self.startIndex = startIndex
  self.endIndex = endIndex
end

function FakeMopUpMarchData:UpdateState(curTime)
  if self.curState == FakeMarchState.FAKE_MARCH_STATE_NULL then
    self:StartMarch()
  elseif self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE and curTime >= self.GarbageStartTime then
    self:CheckAndStartCollectGarbage(curTime)
  elseif self.curState == FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE and curTime >= self.backHomeTime then
    self:CheckAndGoBack(curTime)
  elseif self.curState == FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.arriveHomeTime then
    self:CheckBackHome(curTime)
  end
end

function FakeMopUpMarchData:StartMarch()
  if self.curState == FakeMarchState.FAKE_MARCH_STATE_NULL then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.curState = FakeMarchState.FAKE_MARCH_TO_GARBAGE
    self.startTime = math.ceil(curTime)
    local marchTime = self:CalculateMarchTime()
    self.GarbageStartTime = math.ceil(curTime + marchTime)
    self.backHomeTime = math.ceil(self.GarbageStartTime + self:CalculateCollectGarbageTime())
    self.arriveHomeTime = math.ceil(self.backHomeTime + marchTime)
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.SAMPLE)
    end
  end
end

function FakeMopUpMarchData:CheckAndStartCollectGarbage(curTime)
  if self.curState ~= FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE and curTime >= self.GarbageStartTime then
    self.curState = FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:UpdateFakeSampleMarchDataWhenStartPick(self.endIndex, self.backHomeTime)
    end
  end
end

function FakeMopUpMarchData:CheckAndGoBack(curTime)
  if self.curState ~= FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.backHomeTime then
    self.curState = FakeMarchState.FAKE_MARCH_GO_HOME
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:UpdateFakeSampleMarchDataWhenBack(self.endIndex, self.backHomeTime, self.arriveHomeTime + 1000)
    end
  end
end

function FakeMopUpMarchData:CheckBackHome(curTime)
  if self.curState == FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.arriveHomeTime then
    self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
    self:Remove()
  end
end

function FakeMopUpMarchData:CalculateMarchTime()
  local startPt = SceneUtils.IndexToTilePos(self.startIndex)
  local endPt = SceneUtils.IndexToTilePos(self.endIndex)
  local dis = Vector2.Distance(startPt, endPt)
  local speed = LuaEntry.DataConfig:TryGetNum("armyspeed", "k2")
  local time = dis * 1000 / speed
  return time
end

function FakeMopUpMarchData:CalculateCollectGarbageTime()
  return 3000
end

function FakeMopUpMarchData:Remove()
  if CS.SceneManager:IsInWorld() then
    CS.SceneManager.World:RemoveFakeSampleMarchData(self.endIndex)
  end
end

function FakeMopUpMarchData:NeedRemove()
  if self.curState == FakeMarchState.FAKE_MARCH_ARRIVE_HOME and DataCenter.FakeCollectGarbageMarchManager:NeedRemove(self.pointIndex) then
    return true
  end
  return false
end

function FakeMopUpMarchData:IsEventDoing()
  return self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE or self.curState == FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE
end

function FakeMopUpMarchData:DoWhenBackToWorld()
  if CS.SceneManager.World:ExistMarch(self.endIndex) then
    return
  end
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.endIndex)
  if pointInfo == nil then
    return
  end
  if self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE then
    CS.SceneManager.World:RemoveFakeSampleMarchData(self.endIndex)
    CS.SceneManager.World:AddFakeSampleMarchData(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.SAMPLE)
  else
    self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
    self:UpdateState(UITimeManager:GetInstance():GetServerTime())
  end
end

function FakeMopUpMarchData:GetBackHomeTimeStamp()
  return self.backHomeTime or 0
end

return FakeMopUpMarchData
