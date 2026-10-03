local LWUIWorldBossRewardCtrl = BaseClass("LWUIWorldBossRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIWorldBossRewardCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIWorldBossReward)
end

function LWUIWorldBossRewardCtrl:GetRankRewardList(actId)
  return DataCenter.ActBossDataManager:GetRewardsDataByActId(actId, 1)
end

function LWUIWorldBossRewardCtrl:GetAtkTimeRewardList(actId)
  return DataCenter.ActBossDataManager:GetRewardsDataByActId(actId, 2)
end

return LWUIWorldBossRewardCtrl
