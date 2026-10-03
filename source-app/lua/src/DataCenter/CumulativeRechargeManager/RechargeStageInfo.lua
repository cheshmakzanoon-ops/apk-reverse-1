local RechargeStageInfo = BaseClass("RechargeStageInfo")

local function __init(self)
  self.needScore = nil
  self.reward = {}
  self.stageId = nil
  self.state = nil
end

local function __delete(self)
  self.needScore = nil
  self.reward = nil
  self.stageId = nil
  self.state = nil
end

local function ParseData(self, message)
  if not message then
    return
  end
  if message.needScore then
    self.needScore = message.needScore
  end
  if message.stageId then
    self.stageId = message.stageId
  end
  if message.state then
    self.state = message.state
  end
  if message.reward then
    self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
  end
end

local function UpdateState(self, state)
  self.state = state
end

RechargeStageInfo.__init = __init
RechargeStageInfo.__delete = __delete
RechargeStageInfo.ParseData = ParseData
RechargeStageInfo.UpdateState = UpdateState
return RechargeStageInfo
