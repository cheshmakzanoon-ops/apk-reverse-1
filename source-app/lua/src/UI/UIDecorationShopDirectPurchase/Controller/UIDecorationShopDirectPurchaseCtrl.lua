local UIDirectPurchaseCtrl = BaseClass("UIDirectPurchaseCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDecorationShopDirectPurchase, {anim = true})
end

UIDirectPurchaseCtrl.CloseSelf = CloseSelf
return UIDirectPurchaseCtrl
