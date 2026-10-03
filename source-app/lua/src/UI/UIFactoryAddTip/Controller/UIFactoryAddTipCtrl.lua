local UIFactoryAddTipCtrl = BaseClass("UIFactoryAddTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFactoryAddTip)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIFactoryAddTipCtrl.CloseSelf = CloseSelf
UIFactoryAddTipCtrl.Close = Close
return UIFactoryAddTipCtrl
