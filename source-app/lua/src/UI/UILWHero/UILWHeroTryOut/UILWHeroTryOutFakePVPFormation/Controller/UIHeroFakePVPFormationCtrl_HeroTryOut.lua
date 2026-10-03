local UIHeroFakePVPFormationCtrl_HeroTryOut = BaseClass("UIHeroFakePVPFormationCtrl_HeroTryOut", UIBaseCtrl)

function UIHeroFakePVPFormationCtrl_HeroTryOut:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation_HeroTryOut)
end

return UIHeroFakePVPFormationCtrl_HeroTryOut
