local ActGiftBoxScoreInfo = BaseClass("ActGiftBoxScoreInfo")

local function __init(self)
  self.index = 0
  self.targetScore = 0
  self.reward = {}
  self.state = 0
  self.rewardList = {}
end

local function __delete(self)
  self.index = nil
  self.targetScore = nil
  self.reward = nil
  self.state = nil
  self.rewardList = nil
end

local function ParseInfo(self, message)
  if message == nil then
    return
  end
  if message.index then
    self.index = message.index
  end
  if message.targetScore then
    self.targetScore = message.targetScore
  end
  if message.state then
    self.state = message.state
  end
  table.clear(self.reward)
  if message.reward then
    for i = 1, table.count(message.reward) do
      table.insert(self.reward, message.reward[i])
    end
  end
  if message.reward then
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
  end
end

ActGiftBoxScoreInfo.__init = __init
ActGiftBoxScoreInfo.__delete = __delete
ActGiftBoxScoreInfo.ParseInfo = ParseInfo
return ActGiftBoxScoreInfo
