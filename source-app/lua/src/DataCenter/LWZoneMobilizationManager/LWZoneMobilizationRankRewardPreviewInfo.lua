local LWZoneMobilizationRankRewardPreviewInfo = BaseClass("LWZoneMobilizationRankRewardPreviewInfo")

function LWZoneMobilizationRankRewardPreviewInfo:__init()
  self.minRank = 0
  self.maxRank = 0
  self.rewardList = {}
end

function LWZoneMobilizationRankRewardPreviewInfo:__delete()
  self.minRank = 0
  self.maxRank = 0
  self.rewardList = {}
end

function LWZoneMobilizationRankRewardPreviewInfo:RefreshData(message)
  self.minRank = message.minRank or 0
  self.maxRank = message.maxRank or 0
  self.rewardList = {}
  if message.reward then
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
  end
end

return LWZoneMobilizationRankRewardPreviewInfo
