local LWUIResourceInfoCtrl = BaseClass("LWUIResourceInfoCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBlackMarketProbab, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LWUIResourceInfoCtrl.CloseSelf = CloseSelf
LWUIResourceInfoCtrl.Close = Close
return LWUIResourceInfoCtrl
