local LWUIMonsterInvasionRewardCtrl = BaseClass("LWUIMonsterInvasionRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIMonsterInvasionRewardCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIMonsterInvasionReward)
end

function LWUIMonsterInvasionRewardCtrl:GetRankRewardList(actId)
  return DataCenter.ActivityMonsterInvasionDataManager:GetRewardsDataByActId(actId)
end

return LWUIMonsterInvasionRewardCtrl
