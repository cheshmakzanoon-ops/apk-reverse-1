local UIVIPEffectTipCtrl = BaseClass("UIVIPEffectTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVIPEffectTip)
end

UIVIPEffectTipCtrl.CloseSelf = CloseSelf
return UIVIPEffectTipCtrl
