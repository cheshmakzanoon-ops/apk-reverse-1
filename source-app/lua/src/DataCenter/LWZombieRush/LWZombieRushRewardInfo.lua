local LWZombieRushRewardInfo = BaseClass("LWZombieRushRewardInfo")

function LWZombieRushRewardInfo:__init()
  self.allianceRewardInfoList = {}
  self.personalRewardInfoList = {}
end

function LWZombieRushRewardInfo:__delete()
  self.allianceRewardInfoList = nil
  self.personalRewardInfoList = nil
end

function LWZombieRushRewardInfo:InitRewardMessage(message)
  if message.allianceReward then
    local list = message.allianceReward
    for i, v in pairs(list) do
      local oneData = {}
      oneData.min = v.min or 0
      if v.reward then
        oneData.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(v.reward)
      else
        oneData.rewardList = {}
      end
      table.insert(self.allianceRewardInfoList, oneData)
    end
  end
  if message.personReward then
    local list = message.personReward
    for i, v in pairs(list) do
      local oneData = {}
      oneData.min = v.min or 0
      if v.reward then
        oneData.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(v.reward)
      else
        oneData.rewardList = {}
      end
      table.insert(self.personalRewardInfoList, oneData)
    end
  end
end

return LWZombieRushRewardInfo
