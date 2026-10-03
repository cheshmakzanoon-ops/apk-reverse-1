local UIPinUseSetCtrl = BaseClass("UIPinUseSetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPinUseSet)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIPinUseSetCtrl.CloseSelf = CloseSelf
UIPinUseSetCtrl.Close = Close
return UIPinUseSetCtrl
