local LWBerserkBossAchievementRewardInfo = BaseClass("LWBerserkBossAchievementRewardInfo")

function LWBerserkBossAchievementRewardInfo:__init()
  self.id = 0
  self.reward = {}
end

function LWBerserkBossAchievementRewardInfo:__delete()
  self.id = nil
  self.reward = nil
end

function LWBerserkBossAchievementRewardInfo:InitData(message)
  if message.id then
    self.id = message.id
  end
  if message.reward then
    self.reward = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
  end
end

return LWBerserkBossAchievementRewardInfo
