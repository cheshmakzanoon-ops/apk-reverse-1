local UILWExpiredItemExchangeCtrl = BaseClass("UILWExpiredItemExchangeCtrl", UIBaseCtrl)

function UILWExpiredItemExchangeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWExpiredItemExchange)
end

return UILWExpiredItemExchangeCtrl
