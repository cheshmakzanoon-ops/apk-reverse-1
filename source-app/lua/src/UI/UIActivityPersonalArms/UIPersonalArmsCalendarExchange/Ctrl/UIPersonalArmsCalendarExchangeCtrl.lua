local UIPersonalArmsCalendarExchangeCtrl = BaseClass("UIPersonalArmsCalendarExchangeCtrl", UIBaseCtrl)

function UIPersonalArmsCalendarExchangeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalArmsCalendarExchange)
end

return UIPersonalArmsCalendarExchangeCtrl
