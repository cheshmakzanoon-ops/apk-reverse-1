local UIHeroSimpleTipViewTipCtrl = BaseClass("UIHeroSimpleTipViewTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroSimpleTip)
end

UIHeroSimpleTipViewTipCtrl.CloseSelf = CloseSelf
return UIHeroSimpleTipViewTipCtrl
