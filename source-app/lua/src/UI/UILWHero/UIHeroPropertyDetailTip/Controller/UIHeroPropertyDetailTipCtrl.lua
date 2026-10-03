local UIHeroPropertyDetailTipCtrl = BaseClass("UIHeroPropertyDetailTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPropertyDetailTip)
end

UIHeroPropertyDetailTipCtrl.CloseSelf = CloseSelf
return UIHeroPropertyDetailTipCtrl
