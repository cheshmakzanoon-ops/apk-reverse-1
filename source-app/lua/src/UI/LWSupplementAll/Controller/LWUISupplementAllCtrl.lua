local LWUISupplementAllCtrl = BaseClass("LWUISupplementAllCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSupplementAll, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LWUISupplementAllCtrl.CloseSelf = CloseSelf
LWUISupplementAllCtrl.Close = Close
return LWUISupplementAllCtrl
