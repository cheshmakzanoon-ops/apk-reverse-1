local LWUIMasteryExchangeItemCtrl = BaseClass("LWUIMasteryExchangeItemCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasteryExchangeItem, {anim = useAnimation})
end

LWUIMasteryExchangeItemCtrl.CloseSelf = CloseSelf
return LWUIMasteryExchangeItemCtrl
