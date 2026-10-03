local UIActLotteryWaitOpenRewardInfoCtrl = BaseClass("UIActLotteryWaitOpenRewardInfoCtrl", UIBaseCtrl)

function UIActLotteryWaitOpenRewardInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActLotteryWaitOpenRewardInfo)
end

return UIActLotteryWaitOpenRewardInfoCtrl
