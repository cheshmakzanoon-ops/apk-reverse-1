local LWEffectOverviewHeroDetailCtrl = BaseClass("LWEffectOverviewHeroDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWEffectOverviewHeroDetail)
end

LWEffectOverviewHeroDetailCtrl.CloseSelf = CloseSelf
return LWEffectOverviewHeroDetailCtrl
