local UITransportResCtrl = BaseClass("UITransportResCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITransportRes)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

UITransportResCtrl.CloseSelf = CloseSelf
UITransportResCtrl.Close = Close
return UITransportResCtrl
