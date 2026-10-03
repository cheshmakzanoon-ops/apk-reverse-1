local UIExpiredMonthlyCardRecoverCtrl = BaseClass("UIExpiredMonthlyCardRecoverCtrl", UIBaseCtrl)

function UIExpiredMonthlyCardRecoverCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExpiredMonthlyCardRecover)
end

return UIExpiredMonthlyCardRecoverCtrl
