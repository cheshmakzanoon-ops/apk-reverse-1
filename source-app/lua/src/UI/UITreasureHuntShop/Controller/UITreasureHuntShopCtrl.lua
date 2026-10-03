local UITreasureHuntShopCtrl = BaseClass("UITreasureHuntShopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UITreasureHuntShop, {anim = true})
end

UITreasureHuntShopCtrl.CloseSelf = CloseSelf
return UITreasureHuntShopCtrl
