local UIHeroExchangeGuideCtrl = BaseClass("UIHeroExchangeGuideCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.HeroExchangeGuide)
end

UIHeroExchangeGuideCtrl.CloseSelf = CloseSelf
return UIHeroExchangeGuideCtrl
