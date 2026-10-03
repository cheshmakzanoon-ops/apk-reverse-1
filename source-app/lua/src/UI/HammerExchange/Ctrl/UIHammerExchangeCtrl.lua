local UIHammerExchangeCtrl = BaseClass("UIHammerExchangeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHammerExchange)
end

UIHammerExchangeCtrl.CloseSelf = CloseSelf
return UIHammerExchangeCtrl
