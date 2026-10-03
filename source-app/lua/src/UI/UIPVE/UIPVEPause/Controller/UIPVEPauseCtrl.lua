local UIPVEPauseCtrl = BaseClass("UIPVEPauseCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEPause)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end

UIPVEPauseCtrl.CloseSelf = CloseSelf
UIPVEPauseCtrl.Close = Close
return UIPVEPauseCtrl
