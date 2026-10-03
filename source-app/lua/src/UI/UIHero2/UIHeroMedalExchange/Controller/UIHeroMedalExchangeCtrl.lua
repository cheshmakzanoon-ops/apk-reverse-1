local UIHeroMealExchangeCtrl = BaseClass("UIHeroMealExchangeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroMedalExchange)
end

UIHeroMealExchangeCtrl.CloseSelf = CloseSelf
return UIHeroMealExchangeCtrl
