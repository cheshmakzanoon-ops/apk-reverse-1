local UIHeroTipCtrl = BaseClass("UIHeroTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroTip)
end

UIHeroTipCtrl.CloseSelf = CloseSelf
return UIHeroTipCtrl
