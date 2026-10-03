local UIHeroFragmentEchangePanelCtrl = BaseClass("UIHeroFragmentEchangePanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFragmentExchangePanel)
end

UIHeroFragmentEchangePanelCtrl.CloseSelf = CloseSelf
return UIHeroFragmentEchangePanelCtrl
