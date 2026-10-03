local UIShowFakeNewHeroCtrl = BaseClass("UIShowFakeNewHeroCtrl", UIBaseCtrl)

function UIShowFakeNewHeroCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIShowFakeNewHero)
end

return UIShowFakeNewHeroCtrl
