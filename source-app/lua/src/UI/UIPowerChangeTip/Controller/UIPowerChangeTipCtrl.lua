local UIPowerChangeTipCtrl = BaseClass("UIPowerChangeTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPowerChangeTip)
end

UIPowerChangeTipCtrl.CloseSelf = CloseSelf
return UIPowerChangeTipCtrl
