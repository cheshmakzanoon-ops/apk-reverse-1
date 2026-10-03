local UIGuideTipCtrl = BaseClass("UIGuideTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideTip, {anim = true, playEffect = false})
end

UIGuideTipCtrl.CloseSelf = CloseSelf
return UIGuideTipCtrl
