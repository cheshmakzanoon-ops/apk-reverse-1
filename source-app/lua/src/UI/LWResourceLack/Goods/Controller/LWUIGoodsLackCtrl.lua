local LWUIGoodsLackCtrl = BaseClass("LWUIGoodsLackCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGoodsLack, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LWUIGoodsLackCtrl.CloseSelf = CloseSelf
LWUIGoodsLackCtrl.Close = Close
return LWUIGoodsLackCtrl
