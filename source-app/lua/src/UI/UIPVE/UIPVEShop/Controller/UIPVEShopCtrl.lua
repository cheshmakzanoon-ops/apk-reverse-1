local UIPVEShopCtrl = BaseClass("UIPVEShopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEShop)
end

UIPVEShopCtrl.CloseSelf = CloseSelf
return UIPVEShopCtrl
