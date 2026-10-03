local UIActLotteryItemGetManualCtrl = BaseClass("UIActLotteryItemGetManualCtrl", UIBaseCtrl)

function UIActLotteryItemGetManualCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActLotteryItemGetManual)
end

return UIActLotteryItemGetManualCtrl
