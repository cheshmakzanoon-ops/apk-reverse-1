local LWUIGiftOperationCtrl = BaseClass("LWUIGiftOperationCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftOperation)
end

LWUIGiftOperationCtrl.CloseSelf = CloseSelf
return LWUIGiftOperationCtrl
