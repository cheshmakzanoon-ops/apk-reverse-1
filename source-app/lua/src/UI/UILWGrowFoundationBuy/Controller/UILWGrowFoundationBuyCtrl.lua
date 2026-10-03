local UILWGrowFoundationBuyCtrl = BaseClass("UILWGrowFoundationBuyCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGrowFoundationBuy)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UILWGrowFoundationBuyCtrl.CloseSelf = CloseSelf
UILWGrowFoundationBuyCtrl.Close = Close
return UILWGrowFoundationBuyCtrl
