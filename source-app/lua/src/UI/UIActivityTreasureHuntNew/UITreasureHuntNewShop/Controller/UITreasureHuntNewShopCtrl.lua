local UITreasureHuntNewShopCtrl = BaseClass("UITreasureHuntNewShopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UITreasureHuntNewShop, {anim = true})
end

UITreasureHuntNewShopCtrl.CloseSelf = CloseSelf
return UITreasureHuntNewShopCtrl
