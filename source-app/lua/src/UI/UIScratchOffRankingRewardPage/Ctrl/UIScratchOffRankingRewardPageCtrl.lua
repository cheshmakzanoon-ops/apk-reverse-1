local UIScratchOffRankingRewardPageCtrl = BaseClass("UIScratchOffRankingRewardPageCtrl", UIBaseCtrl)

function UIScratchOffRankingRewardPageCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIScratchOffRankingRewardPage)
end

return UIScratchOffRankingRewardPageCtrl
