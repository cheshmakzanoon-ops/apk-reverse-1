local UIParkourFormationPanelCtrl_HeroTryOut = BaseClass("UIParkourFormationPanelCtrl_HeroTryOut", UIBaseCtrl)

function UIParkourFormationPanelCtrl_HeroTryOut:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourFormation_HeroTryOut)
end

return UIParkourFormationPanelCtrl_HeroTryOut
