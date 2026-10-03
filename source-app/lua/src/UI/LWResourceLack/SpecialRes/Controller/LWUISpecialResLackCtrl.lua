local LWUISpecialResLackCtrl = BaseClass("LWUISpecialResLackCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSpecialResLack, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LWUISpecialResLackCtrl.CloseSelf = CloseSelf
LWUISpecialResLackCtrl.Close = Close
return LWUISpecialResLackCtrl
