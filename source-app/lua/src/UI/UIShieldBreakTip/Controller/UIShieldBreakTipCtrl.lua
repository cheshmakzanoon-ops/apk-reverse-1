local UIShieldBreakTipCtrl = BaseClass("UIShieldBreakTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIShieldBreakTip, {anim = true, playEffect = false})
end

UIShieldBreakTipCtrl.CloseSelf = CloseSelf
return UIShieldBreakTipCtrl
