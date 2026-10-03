local LWUICommonRankRewardCtrl = BaseClass("LWUICommonRankRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUICommonRankRewardCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUICommonRankReward)
end

return LWUICommonRankRewardCtrl
