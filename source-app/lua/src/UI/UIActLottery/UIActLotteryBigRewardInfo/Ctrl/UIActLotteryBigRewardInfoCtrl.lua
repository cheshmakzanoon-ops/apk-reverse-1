local UIActLotteryBigRewardInfoCtrl = BaseClass("UIActLotteryBigRewardInfoCtrl", UIBaseCtrl)

function UIActLotteryBigRewardInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActLotteryBigRewardInfo)
end

return UIActLotteryBigRewardInfoCtrl
