local UIPingCtrl = BaseClass("UIPingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPing)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIPingCtrl.CloseSelf = CloseSelf
UIPingCtrl.Close = Close
return UIPingCtrl
