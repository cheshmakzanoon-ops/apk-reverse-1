local UIPVEDebugCtrl = BaseClass("UIPVEDebugCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEDebug, {anim = true})
end

UIPVEDebugCtrl.CloseSelf = CloseSelf
return UIPVEDebugCtrl
