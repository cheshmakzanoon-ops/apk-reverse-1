local UIHeroUWEnhanceAttrTipCtrl = BaseClass("UIHeroUWEnhanceAttrTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroUWEnhanceAttrTip)
end

UIHeroUWEnhanceAttrTipCtrl.CloseSelf = CloseSelf
return UIHeroUWEnhanceAttrTipCtrl
