local UICommonShopCtrl = BaseClass("UICommonShopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroResetShop, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

UICommonShopCtrl.CloseSelf = CloseSelf
UICommonShopCtrl.Close = Close
return UICommonShopCtrl
