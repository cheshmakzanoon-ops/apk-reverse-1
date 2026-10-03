local LWUIGiftDetailCtrl = BaseClass("LWUIGiftDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftDetail_v2)
end

LWUIGiftDetailCtrl.CloseSelf = CloseSelf
return LWUIGiftDetailCtrl
