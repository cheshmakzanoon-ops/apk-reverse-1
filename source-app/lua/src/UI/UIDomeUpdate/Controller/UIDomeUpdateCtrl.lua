local UIDomeUpdateCtrl = BaseClass("UIDomeUpdateCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDomeUpdate)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIDomeUpdateCtrl.CloseSelf = CloseSelf
UIDomeUpdateCtrl.Close = Close
return UIDomeUpdateCtrl
