local LWZoneMobilizationDailyTaskInfo = BaseClass("LWZoneMobilizationDailyTaskInfo")

function LWZoneMobilizationDailyTaskInfo:__init()
  self.taskId = 0
  self.num = 0
  self.state = 0
  self.reward = {}
end

function LWZoneMobilizationDailyTaskInfo:__delete()
  self.taskId = nil
  self.num = nil
  self.state = nil
  self.reward = nil
  self.activityTaskTemplate = nil
end

function LWZoneMobilizationDailyTaskInfo:InitData(message)
  self.taskId = message.taskId or 0
  self.num = message.num or 0
  self.state = message.state or 0
  self.reward = {}
  if message.reward then
    self.reward = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
  end
end

function LWZoneMobilizationDailyTaskInfo:UpdateTaskState(newState)
  self.state = newState
end

return LWZoneMobilizationDailyTaskInfo
