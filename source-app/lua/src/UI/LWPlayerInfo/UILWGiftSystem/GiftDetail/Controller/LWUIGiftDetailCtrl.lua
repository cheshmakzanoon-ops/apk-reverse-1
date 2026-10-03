local LWUIGiftDetailCtrl = BaseClass("LWUIGiftDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftDetail)
end

LWUIGiftDetailCtrl.CloseSelf = CloseSelf
return LWUIGiftDetailCtrl
