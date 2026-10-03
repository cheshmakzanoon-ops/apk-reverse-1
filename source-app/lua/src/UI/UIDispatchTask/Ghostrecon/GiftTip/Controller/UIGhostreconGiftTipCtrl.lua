local UIGhostreconGiftTipCtrl = BaseClass("UIGhostreconGiftTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconGiftTip)
end

UIGhostreconGiftTipCtrl.CloseSelf = CloseSelf
return UIGhostreconGiftTipCtrl
