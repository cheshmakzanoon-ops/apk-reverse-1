local base = require("DataCenter.RadarCenterDataManager.FakeCollectGarbageMarchData")
local FakeCollectGarbageMarchData = BaseClass("FakeCollectGarbageMarchData", base)

local function __init(self)
  self.funGetDetectReward = BindCallback(self, self.OnGetDetectReward)
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self.funGetDetectReward = nil
end

local function AddListener(self)
  if self.funGetDetectReward then
    EventManager:GetInstance():AddListener(EventId.LWDetectEventRewardReceive, self.funGetDetectReward)
  end
end

local function RemoveListener(self)
  if self.funGetDetectReward then
    EventManager:GetInstance():RemoveListener(EventId.LWDetectEventRewardReceive, self.funGetDetectReward)
  end
end

local function SendPickEndMessage(self)
  self.callTime = UITimeManager:GetInstance():GetServerTime()
  SFSNetwork.SendMessage(MsgDefines.FinishVisitor, self.uuid)
end

local function SetStartAndEndIndex(self, pointIndex, startIndex, endIndex)
  self.pointIndex = pointIndex
  self.startIndex = startIndex
  self.endIndex = endIndex
  local data = CS.SceneManager.World:GetPointInfo(self.pointIndex)
  if data then
    self.pointUid = data.uuid
    self.uuid = data.uuid
  end
  local detectEventData = DataCenter.RadarCenterDataManager:GetNotFinishDetectEventInfoByPointId(self.pointIndex)
  if detectEventData ~= nil then
    self.pointUid = detectEventData.uuid
    self.uuid = detectEventData.uuid
    self.curState = 2
    SFSNetwork.SendMessage(MsgDefines.StartPickGarbage, detectEventData.uuid)
    SFSNetwork.SendMessage(MsgDefines.FinishSampling, detectEventData.uuid)
    SFSNetwork.SendMessage(MsgDefines.FinishVisitor, detectEventData.uuid)
    SFSNetwork.SendMessage(MsgDefines.DetectEventRewardReceive, detectEventData.uuid)
    return
  end
end

function FakeCollectGarbageMarchData:Remove()
  self:RemoveListener()
  self.funGetDetectReward = nil
end

function FakeCollectGarbageMarchData:UpdateState(curTime)
end

function FakeCollectGarbageMarchData:NeedRemove()
  return self.curState == 4
end

function FakeCollectGarbageMarchData:OnGetDetectReward(evtData)
  if evtData and self.uuid and self.uuid == evtData.eventUuid then
    self.curState = 4
    DataCenter.RewardManager:ShowCommonReward(evtData, nil, nil, nil, nil, nil, function()
    end)
  end
end

FakeCollectGarbageMarchData.__init = __init
FakeCollectGarbageMarchData.__delete = __delete
FakeCollectGarbageMarchData.AddListener = AddListener
FakeCollectGarbageMarchData.RemoveListener = RemoveListener
FakeCollectGarbageMarchData.SetStartAndEndIndex = SetStartAndEndIndex
FakeCollectGarbageMarchData.SendPickEndMessage = SendPickEndMessage
return FakeCollectGarbageMarchData
