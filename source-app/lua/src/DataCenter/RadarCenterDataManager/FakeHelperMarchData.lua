local FakeHelperMarchData = BaseClass("FakeHelperMarchData")
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
  self.startServerId = 0
  self.endServerId = 0
  self.startTime = 0
  self.GarbageStartTime = 0
  self.backHomeTime = 0
  self.arriveHomeTime = 0
  self.curState = FakeMarchState.FAKE_MARCH_STATE_NULL
end

local function __delete(self)
  self.startIndex = nil
  self.endIndex = nil
  self.startServerId = nil
  self.endServerId = nil
  self.startTime = nil
  self.GarbageStartTime = nil
  self.backHomeTime = nil
  self.arriveHomeTime = nil
end

local function SetStartAndEndIndex(self, pointIndex, startIndex, endIndex, serverId)
  if serverId == nil then
    serverId = LuaEntry.Player:GetSelfServerId()
  end
  self.pointIndex = pointIndex
  self.startIndex = startIndex
  self.endIndex = endIndex
  self.startServerId = serverId
  self.endServerId = serverId
  local data = CS.SceneManager.World:GetPointInfo(self.pointIndex)
  if data then
    self.pointUid = data.uuid
    self.uuid = data.uuid
  end
  local detectData = DataCenter.RadarCenterDataManager:GetHelperEventDataByBuildUid(self.pointUid)
  if detectData then
    self.eventUuid = detectData.uuid
  else
    local detectEventData = DataCenter.RadarCenterDataManager:GetNotFinishDetectEventInfoByPointId(self.pointIndex)
    if detectEventData ~= nil then
      self.eventUuid = detectEventData.uuid
    end
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
    self.curState = FakeMarchState.FAKE_MARCH_TO_GARBAGE
    self.startTime = math.ceil(curTime)
    local marchTime = self:CalculateMarchTime()
    self.GarbageStartTime = math.ceil(curTime + marchTime)
    self.backHomeTime = math.ceil(self.GarbageStartTime + self:CalculateCollectGarbageTime())
    self.arriveHomeTime = math.ceil(self.backHomeTime + marchTime + 1000)
    local eventUuid = self.eventUuid
    SFSNetwork.SendMessage(MsgDefines.DetectEventHelpStart, eventUuid, DetectEventType.HELPER)
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:AddFakeSampleMarchDataWithServerId(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.NORMAL_FAKE_MARCH, self.startServerId, self.endServerId)
    end
  end
end

local function CheckAndStartCollectGarbage(self, curTime)
  if self.curState ~= FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE and curTime >= self.GarbageStartTime then
    self.curState = FakeMarchState.FAKE_MARCH_COLLECT_GARBAGE
    if CS.SceneManager:IsInWorld() then
    end
  end
end

local function CheckAndGoBack(self, curTime)
  if self.curState ~= FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.backHomeTime then
    self.curState = FakeMarchState.FAKE_MARCH_GO_HOME
    if CS.SceneManager:IsInWorld() then
      CS.SceneManager.World:UpdateFakeSampleMarchDataWhenBack(self.endIndex, self.backHomeTime, self.arriveHomeTime)
      self:SendPickEndMessage()
    end
  end
end

local function SendPickEndMessage(self)
  if self.curState == FakeMarchState.FAKE_MARCH_GO_HOME or self.curState == FakeMarchState.FAKE_MARCH_ARRIVE_HOME then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.eventUuid ~= nil and (self.callTime == nil or now - self.callTime > retry_gap_time) then
      self.callTime = now
      local eventUuid = self.eventUuid
      local detectData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(eventUuid)
      if detectData ~= nil and detectData.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
        SFSNetwork.SendMessage(MsgDefines.DetectEventHelpEnd, eventUuid, DetectEventType.HELPER)
        if CS.SceneManager.World and self.uuid == nil then
          local data = CS.SceneManager.World:GetPointInfo(self.pointIndex)
          if data then
            self.uuid = data.uuid
          end
        end
        if self.uuid ~= nil then
          local playerInfo
          if detectData.helpInfo ~= nil then
            playerInfo = {
              uid = detectData.helpInfo.uid,
              pic = detectData.helpInfo.pic,
              picVer = detectData.helpInfo.picVer
            }
          end
          EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubblePlot, {
            bUuid = self.uuid,
            plotId = 6022,
            playerInfo = playerInfo
          })
          EventManager:GetInstance():Broadcast(EventId.HelpDetectEndEffectBubbleShow, {
            bUuid = self.uuid
          })
          BuildTopBubbleManager:GetInstance():RemoveOneEffect(tonumber(self.uuid))
        end
      end
    end
  end
end

local function CheckBackHome(self, curTime)
  if self.curState == FakeMarchState.FAKE_MARCH_GO_HOME and curTime >= self.arriveHomeTime then
    self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
    DataCenter.FakeHelperMarchManager:RemoveMarchIndex(self.endIndex)
  end
end

local function CalculateMarchTime(self)
  local startPt = SceneUtils.IndexToTilePos(self.startIndex)
  local endPt = SceneUtils.IndexToTilePos(self.endIndex)
  local dis = Vector2.Distance(startPt, endPt)
  local speed = 3
  local time = dis * 1000 / speed
  local maxTime = 10000
  if time > maxTime then
    time = maxTime
  end
  return time
end

local function CalculateCollectGarbageTime(self)
  return 1
end

local function Remove(self)
  if CS.SceneManager:IsInWorld() then
    CS.SceneManager.World:RemoveFakeSampleMarchData(self.endIndex)
  end
end

local function NeedRemove(self)
  if self.curState == FakeMarchState.FAKE_MARCH_ARRIVE_HOME and DataCenter.FakeHelperMarchManager:NeedRemove(self.eventUuid) then
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
  if self.curState == FakeMarchState.FAKE_MARCH_TO_GARBAGE then
    CS.SceneManager.World:RemoveFakeSampleMarchData(self.endIndex)
    CS.SceneManager.World:AddFakeSampleMarchDataWithServerId(self.startIndex, self.endIndex, self.startTime, self.GarbageStartTime, MarchTargetType.NORMAL_FAKE_MARCH, self.startServerId, self.endServerId)
  else
    self.curState = FakeMarchState.FAKE_MARCH_ARRIVE_HOME
    self:UpdateState(UITimeManager:GetInstance():GetServerTime())
  end
end

FakeHelperMarchData.__init = __init
FakeHelperMarchData.__delete = __delete
FakeHelperMarchData.SetStartAndEndIndex = SetStartAndEndIndex
FakeHelperMarchData.StartMarch = StartMarch
FakeHelperMarchData.CheckAndStartCollectGarbage = CheckAndStartCollectGarbage
FakeHelperMarchData.CheckAndGoBack = CheckAndGoBack
FakeHelperMarchData.CalculateMarchTime = CalculateMarchTime
FakeHelperMarchData.CalculateCollectGarbageTime = CalculateCollectGarbageTime
FakeHelperMarchData.UpdateState = UpdateState
FakeHelperMarchData.Remove = Remove
FakeHelperMarchData.CheckBackHome = CheckBackHome
FakeHelperMarchData.SendPickEndMessage = SendPickEndMessage
FakeHelperMarchData.NeedRemove = NeedRemove
FakeHelperMarchData.IsEventDoing = IsEventDoing
FakeHelperMarchData.DoWhenBackToWorld = DoWhenBackToWorld
return FakeHelperMarchData
