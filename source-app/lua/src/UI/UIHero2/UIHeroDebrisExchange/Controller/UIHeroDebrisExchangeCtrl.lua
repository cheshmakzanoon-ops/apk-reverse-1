local UIHeroDebrisExchangeCtrl = BaseClass("UIHeroMealExchangeCtrl", UIBaseCtrl)

local function CloseSelf(self, fromHeroLackTip, needNum, heroId, requireNum)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroDebrisExchange)
  if fromHeroLackTip and 0 < needNum then
    DataCenter.HeroLackTipManager:GotoGetHero(heroId, requireNum)
  end
end

UIHeroDebrisExchangeCtrl.CloseSelf = CloseSelf
return UIHeroDebrisExchangeCtrl
