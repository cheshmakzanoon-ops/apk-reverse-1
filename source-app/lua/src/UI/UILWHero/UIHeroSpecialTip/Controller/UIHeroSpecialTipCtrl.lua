local UIHeroSpecialTipCtrl = BaseClass("UIHeroSpecialTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroSpecialTip)
end

UIHeroSpecialTipCtrl.CloseSelf = CloseSelf
return UIHeroSpecialTipCtrl
