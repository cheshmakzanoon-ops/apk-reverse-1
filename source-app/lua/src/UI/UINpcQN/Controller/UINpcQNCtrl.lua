local UINpcQNCtrl = BaseClass("UINpcQNCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINpcQN)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UINpcQNCtrl.CloseSelf = CloseSelf
UINpcQNCtrl.Close = Close
return UINpcQNCtrl
