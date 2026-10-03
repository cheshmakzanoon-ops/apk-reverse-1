local LWTitaniumBlueBoxRewardInfo = BaseClass("LWTitaniumBlueBoxRewardInfo")

function LWTitaniumBlueBoxRewardInfo:__init()
  self.index = 0
  self.targetCount = 0
  self.rewardsList = {}
end

function LWTitaniumBlueBoxRewardInfo:__delete()
  self.index = nil
  self.targetCount = nil
  self.rewardsList = nil
end

function LWTitaniumBlueBoxRewardInfo:InitData(message)
  if message.index then
    self.index = message.index
  end
  if message.target then
    self.targetCount = message.target
  end
  if message.reward then
    self.rewardsList = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
  end
end

return LWTitaniumBlueBoxRewardInfo
