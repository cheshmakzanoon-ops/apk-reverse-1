local LWUIGiftOperationCtrl = BaseClass("LWUIGiftOperationCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftOperation_v2)
end

LWUIGiftOperationCtrl.CloseSelf = CloseSelf
return LWUIGiftOperationCtrl
