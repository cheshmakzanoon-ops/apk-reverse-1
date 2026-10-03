local UIPinForgetCtrl = BaseClass("UIPinForgetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPinForget)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIPinForgetCtrl.CloseSelf = CloseSelf
UIPinForgetCtrl.Close = Close
return UIPinForgetCtrl
