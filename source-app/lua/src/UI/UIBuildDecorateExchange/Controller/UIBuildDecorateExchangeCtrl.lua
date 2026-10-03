local UIBuildDecorateExchangeCtrl = BaseClass("UIBuildDecorateExchangeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildDecorateExchange)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIBuildDecorateExchangeCtrl.CloseSelf = CloseSelf
UIBuildDecorateExchangeCtrl.Close = Close
return UIBuildDecorateExchangeCtrl
