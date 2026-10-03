local UIPayCurrencyLockCtrl = BaseClass("UIPayCurrencyLockCtrl", UIBaseCtrl)

function UIPayCurrencyLockCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPayCurrencyLock)
end

return UIPayCurrencyLockCtrl
