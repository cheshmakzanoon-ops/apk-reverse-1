local LWUIGiftShopCtrl = BaseClass("LWUIGiftShopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftShop)
end

LWUIGiftShopCtrl.CloseSelf = CloseSelf
return LWUIGiftShopCtrl
