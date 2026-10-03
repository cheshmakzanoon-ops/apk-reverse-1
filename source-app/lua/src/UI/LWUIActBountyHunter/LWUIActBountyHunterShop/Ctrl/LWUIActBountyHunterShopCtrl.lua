local LWUIActBountyHunterShopCtrl = BaseClass("LWUIActBountyHunterShopCtrl", UIBaseCtrl)

function LWUIActBountyHunterShopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActBountyHunterShop)
end

return LWUIActBountyHunterShopCtrl
