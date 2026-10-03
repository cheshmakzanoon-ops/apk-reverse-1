local UISoliderGetTipCtrl = BaseClass("UISoliderGetTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISoliderGetTip, {anim = false, playEffect = false})
end

UISoliderGetTipCtrl.CloseSelf = CloseSelf
return UISoliderGetTipCtrl
