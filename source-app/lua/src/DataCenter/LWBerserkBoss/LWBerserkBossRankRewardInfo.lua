local LWBerserkBossRankRewardInfo = BaseClass("LWBerserkBossRankRewardInfo")

function LWBerserkBossRankRewardInfo:__init()
  self.rankLow = 0
  self.rankHigh = 0
  self.reward = {}
end

function LWBerserkBossRankRewardInfo:__delete()
  self.rankLow = nil
  self.rankHigh = nil
  self.reward = nil
end

function LWBerserkBossRankRewardInfo:InitData(message)
  if message.rankLow then
    self.rankLow = message.rankLow
  end
  if message.rankHigh then
    self.rankHigh = message.rankHigh
  end
  if message.reward then
    self.reward = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
  end
end

return LWBerserkBossRankRewardInfo
