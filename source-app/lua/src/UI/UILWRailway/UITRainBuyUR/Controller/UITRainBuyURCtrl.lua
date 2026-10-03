local UITRainBuyURCtrl = BaseClass("UITRainBuyURCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainBuyUR)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UITRainBuyURCtrl.CloseSelf = CloseSelf
UITRainBuyURCtrl.Close = Close
return UITRainBuyURCtrl
