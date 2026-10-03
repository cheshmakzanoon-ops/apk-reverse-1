local UIForceUpdateTipCtrl = BaseClass("UIForceUpdateTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIForceUpdateTip, {anim = true})
end

UIForceUpdateTipCtrl.CloseSelf = CloseSelf
return UIForceUpdateTipCtrl
