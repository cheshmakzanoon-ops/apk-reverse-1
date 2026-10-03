local UILuckyRollShopCtrl = BaseClass("UILuckyRollShopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILuckyRollShop, {anim = true})
end

UILuckyRollShopCtrl.CloseSelf = CloseSelf
return UILuckyRollShopCtrl
