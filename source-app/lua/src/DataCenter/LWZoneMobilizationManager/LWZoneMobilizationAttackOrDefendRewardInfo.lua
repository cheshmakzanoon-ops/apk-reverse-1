local LWZoneMobilizationAttackOrDefendRewardInfo = BaseClass("LWZoneMobilizationAttackOrDefendRewardInfo")

function LWZoneMobilizationAttackOrDefendRewardInfo:__init()
  self.targetValue = 0
  self.rewarded = false
  self.rewardList = {}
end

function LWZoneMobilizationAttackOrDefendRewardInfo:__delete()
  self.targetValue = nil
  self.rewarded = nil
  self.rewardList = nil
end

function LWZoneMobilizationAttackOrDefendRewardInfo:RefreshData(message)
  self.targetValue = message.target or 0
  self.rewarded = message.rewarded or false
  self.rewardList = {}
  if message.reward then
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
  end
end

function LWZoneMobilizationAttackOrDefendRewardInfo:UpdateReceivedState(isReceived)
  self.rewarded = isReceived
end

return LWZoneMobilizationAttackOrDefendRewardInfo
