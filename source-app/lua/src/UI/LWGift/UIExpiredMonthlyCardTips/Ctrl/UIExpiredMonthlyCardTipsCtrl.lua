local UIExpiredMonthlyCardTipsCtrl = BaseClass("UIExpiredMonthlyCardTipsCtrl", UIBaseCtrl)

function UIExpiredMonthlyCardTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExpiredMonthlyCardTips)
end

return UIExpiredMonthlyCardTipsCtrl
