local UINewHeroCtrl = BaseClass("UINewHeroCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINewHero)
end

UINewHeroCtrl.CloseSelf = CloseSelf
return UINewHeroCtrl
