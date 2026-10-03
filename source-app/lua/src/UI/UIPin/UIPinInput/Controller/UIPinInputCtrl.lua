local UIPinInputCtrl = BaseClass("UIPinInputCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPinInput)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end

UIPinInputCtrl.CloseSelf = CloseSelf
UIPinInputCtrl.Close = Close
return UIPinInputCtrl
