local UITrainBuyCtrl = BaseClass("UITrainBuyCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainBuy)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UITrainBuyCtrl.CloseSelf = CloseSelf
UITrainBuyCtrl.Close = Close
return UITrainBuyCtrl
