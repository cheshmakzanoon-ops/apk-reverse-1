local UIPinSetCtrl = BaseClass("UIPinSetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPinSet)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIPinSetCtrl.CloseSelf = CloseSelf
UIPinSetCtrl.Close = Close
return UIPinSetCtrl
