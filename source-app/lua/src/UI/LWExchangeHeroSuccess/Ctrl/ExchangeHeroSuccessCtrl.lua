local ExchangeHeroSuccessCtrl = BaseClass("ExchangeHeroSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ExchangeHeroSuccess)
end

ExchangeHeroSuccessCtrl.CloseSelf = CloseSelf
return ExchangeHeroSuccessCtrl
