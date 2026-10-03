local DailyTaskInfo = BaseClass("DailyTaskInfo")

local function __init(self)
  self.id = 0
  self.num = 0
  self.totalNum = 0
  self.totalTimes = 0
  self.state = 0
  self.reward = {}
end

local function __delete(self)
  self.id = nil
  self.num = nil
  self.totalNum = nil
  self.totalTimes = nil
  self.state = nil
  self.reward = nil
end

local function UpdateInfo(self, message)
  if message == nil then
    return
  end
  if message.id ~= nil then
    self.id = message.id
  end
  if message.num ~= nil then
    self.num = message.num
  end
  if message.totalNum ~= nil then
    self.totalNum = message.totalNum
  end
  if message.totalTimes ~= nil then
    self.totalTimes = message.totalTimes
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.reward ~= nil then
    self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
  end
end

DailyTaskInfo.__init = __init
DailyTaskInfo.__delete = __delete
DailyTaskInfo.UpdateInfo = UpdateInfo
return DailyTaskInfo
