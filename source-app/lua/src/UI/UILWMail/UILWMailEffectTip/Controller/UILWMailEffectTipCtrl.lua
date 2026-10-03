local UILWMailEffectTipCtrl = BaseClass("UILWMailEffectTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWMailEffectTip, {anim = true})
end

UILWMailEffectTipCtrl.CloseSelf = CloseSelf
return UILWMailEffectTipCtrl
