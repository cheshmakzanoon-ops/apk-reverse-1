local LWUICommonRankMultipleRewardCtrl = BaseClass("LWUICommonRankMultipleRewardCtrl", UIBaseCtrl)

function LWUICommonRankMultipleRewardCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUICommonRankMultipleReward)
end

return LWUICommonRankMultipleRewardCtrl
