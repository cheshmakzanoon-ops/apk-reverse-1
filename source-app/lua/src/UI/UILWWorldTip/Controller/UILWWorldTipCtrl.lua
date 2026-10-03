local UILWWorldTipCtrl = BaseClass("UILWWorldTip", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWWorldTip, {anim = false})
end

UILWWorldTipCtrl.CloseSelf = CloseSelf
return UILWWorldTipCtrl
