local UIFireworkGoodsLackCtrl = BaseClass("UIFireworkGoodsLackCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFireworkGoodsLack, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIFireworkGoodsLackCtrl.CloseSelf = CloseSelf
UIFireworkGoodsLackCtrl.Close = Close
return UIFireworkGoodsLackCtrl
