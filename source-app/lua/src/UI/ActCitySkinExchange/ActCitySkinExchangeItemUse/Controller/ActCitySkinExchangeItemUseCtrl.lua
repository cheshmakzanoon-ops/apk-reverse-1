local ActCitySkinExchangeItemUseCtrl = BaseClass("ActCitySkinExchangeItemUseCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ActCitySkinExchangeItemUse, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

ActCitySkinExchangeItemUseCtrl.CloseSelf = CloseSelf
ActCitySkinExchangeItemUseCtrl.Close = Close
return ActCitySkinExchangeItemUseCtrl
